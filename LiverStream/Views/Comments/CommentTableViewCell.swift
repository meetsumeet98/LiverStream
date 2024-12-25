import UIKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15 // Rounded
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear // Transparent background
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(messageLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 10, y: 5, width: 30, height: 30)
        usernameLabel.frame = CGRect(x: 50, y: 5, width: contentView.frame.width - 60, height: 15)
        messageLabel.frame = CGRect(x: 50, y: 25, width: contentView.frame.width - 60, height: 20)
    }

    func configure(with comment: Comment) {
        usernameLabel.text = comment.username
        messageLabel.text = comment.comment
        if let url = URL(string: comment.picURL) {
            // Load the image asynchronously
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
        }
    }
}
