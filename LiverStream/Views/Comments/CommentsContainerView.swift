import UIKit

class CommentsContainerView: UIView, CommentsManagerDelegate {
    private let gradientLayer = CAGradientLayer()

    private let commentsManager: CommentsManager
    private let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override init(frame: CGRect) {
        commentsManager = CommentsManager(withCommentsTableView: commentsTableView)
        super.init(frame: frame)
        commentsManager.delegate = self
        setupCommentsTableView()
        setupTopMaskView()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCommentsTableView() {
        commentsTableView.dataSource = commentsManager
        commentsTableView.delegate = commentsManager
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        addSubview(commentsTableView)

        NSLayoutConstraint.activate([
            commentsTableView.bottomAnchor.constraint(equalTo: topAnchor),
            commentsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            commentsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            commentsTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
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

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayerFrame()
    }

    private func setupTopMaskView() {
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor, // Fully transparent at the top
            UIColor.white.withAlphaComponent(0.5).cgColor,
        ]
        gradientLayer.locations = [0.0, 0.2] // Smooth gradient transition
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Start from the top-left
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)  // End at the bottom-left (vertical fade)

        layer.mask = gradientLayer
    }

    private func updateGradientLayerFrame() {
        CATransaction.begin()
        CATransaction.setDisableActions(true) // Disable implicit animations
        gradientLayer.frame = bounds
        CATransaction.commit()
    }

    func scrollViewDidScroll() {
        updateGradientLayerFrame()
    }
}

