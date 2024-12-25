import UIKit

class CommentsView: UIView, UITableViewDataSource {
    private var comments: [Comment] = []

    private let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isUserInteractionEnabled = false // Disable interactions
        return tableView
    }()

    private func setupCommentsTableView() {
        commentsTableView.dataSource = self
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

    private var timer: Timer?

    private var currentCommentIndex = 0

    deinit {
        timer?.invalidate() // Stop the timer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommentsTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadComments() {
        guard let url = Bundle.main.url(forResource: "comments", withExtension: "json") else {
            print("Failed to locate JSON file.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let commentsResponse = try JSONDecoder().decode(CommentsResponse.self, from: data)
            comments = commentsResponse.comments
            print("#SB - loadComments: comments \(comments.count)")
            commentsTableView.reloadData()
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }

    func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if !self.comments.isEmpty {
                // Add a new comment to the end of the array
                let comment = self.comments[self.currentCommentIndex % self.comments.count]
                self.comments.append(comment)
                self.currentCommentIndex += 1

                // Reload and scroll to the latest comment
                self.commentsTableView.reloadData()

                // Ensure the row exists before scrolling
                let lastRow = self.comments.count - 1
                if lastRow >= 0 && lastRow < self.commentsTableView.numberOfRows(inSection: 0) {
                    let indexPath = IndexPath(row: lastRow, section: 0)
                    self.commentsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }

    // MARK: -  UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            fatalError("Could not dequeue CommentTableViewCell")
        }
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}

