import UIKit

class CommentsContainerView: UIView {

    // MARK: - Properties

    private let gradientLayer = CAGradientLayer()
    let commentsManager: CommentsManager
    private let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - LifeCycle Methods

    override init(frame: CGRect) {
        commentsManager = CommentsManager(withCommentsTableView: commentsTableView)
        super.init(frame: frame)
        setupCommentsTableView()
        setupTopMaskView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds

        // Setting top inset here to give the visual effect that 1st comment comes on screen from the bottom of the tableview
        commentsTableView.contentInset = UIEdgeInsets(top: commentsTableView.frame.height, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Private Helpers

    private func setupCommentsTableView() {
        commentsTableView.dataSource = commentsManager
        commentsTableView.delegate = commentsManager
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        addSubview(commentsTableView)

        NSLayoutConstraint.activate([
            commentsTableView.topAnchor.constraint(equalTo: topAnchor),
            commentsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            commentsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            commentsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    private func setupTopMaskView() {
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor, // Fully transparent at the top
            UIColor.white.withAlphaComponent(1).cgColor,
        ]
        gradientLayer.locations = [0.0, 0.2]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        layer.mask = gradientLayer
    }

    // MARK: - Internal Methods

    func loadComments() {
        commentsManager.loadComments()
    }

    func addCommentAndScroll(_ comment: Comment) {
        commentsManager.addCommentAndScroll(comment)
    }
}

