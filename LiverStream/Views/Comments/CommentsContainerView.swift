import UIKit

class CommentsContainerView: UIView {
    private let commentsManager: CommentsManager
    private let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    override init(frame: CGRect) {
        commentsManager = CommentsManager(withCommentsTableView: commentsTableView)
        super.init(frame: frame)
        setupCommentsTableView()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCommentsTableView() {
        commentsTableView.dataSource = commentsManager
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(commentsTableView)

        NSLayoutConstraint.activate([
            commentsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            commentsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            commentsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            commentsTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func loadComments() {
        commentsManager.loadComments()
    }

    func startAutoScroll() {
        commentsManager.startAutoScroll()
    }

    func addComment(_ comment: Comment) {
        commentsManager.addComment(comment)
    }
}

