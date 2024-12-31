import UIKit

class CommentTableViewCell: UITableViewCell {

    // MARK: - Constants

    static let identifier = "CommentTableViewCell"
    static let avatarSize = CGSize(width: 27, height: 27)

    // MARK: - Properties

    private let contentStackview: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .fill
        stackview.alignment = .top
        stackview.spacing = 6
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()

    private let labelStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.spacing = 2
        return stackview
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    // MARK: - LifeCycle Methods

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupViewHierarchy()
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        messageLabel.text = nil
        profileImageView.image = nil
    }

    // MARK: - Private Helpers

    private func setupViewHierarchy() {
        labelStackView.addArrangedSubview(usernameLabel)
        labelStackView.addArrangedSubview(messageLabel)

        contentStackview.addArrangedSubview(profileImageView)
        contentStackview.addArrangedSubview(labelStackView)

        contentView.addSubview(contentStackview)
    }

    private func setupViewLayout() {
        let profileImageWidthConstraint = profileImageView.widthAnchor.constraint(equalToConstant: Self.avatarSize.width)
        let profileImageHeightConstraint = profileImageView.heightAnchor.constraint(equalToConstant: Self.avatarSize.height)

        // Lower down the custom constraint priority since the profileImageView constraints is managed by stackview
        [profileImageWidthConstraint, profileImageHeightConstraint].forEach {
            $0.priority = .required - 1
        }
        NSLayoutConstraint.activate([
            profileImageWidthConstraint,
            profileImageHeightConstraint,

            contentStackview.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            contentStackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    // MARK: - Internal Methods

    func configure(with comment: Comment) {
        usernameLabel.text = comment.username
        messageLabel.text = comment.comment
        if let url = URL(string: comment.picURL) {
            // Load the image asynchronously
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
        }
    }
}
