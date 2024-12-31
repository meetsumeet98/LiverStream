import UIKit

class CommentsManager: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    // Complete collection of comments
    private var allComments: [Comment] = []

    // TableView data source
    private var comments:  [Comment] = []

    let commentsTableView: UITableView
    private var timer: Timer?
    private var currentCommentIndex = 0

    // MARK: - LifeCycle Methods

    init(withCommentsTableView commentsTableView: UITableView) {
        self.commentsTableView = commentsTableView
    }

    deinit {
        timer?.invalidate() // Stop the timer
    }

    // MARK: - Private Helpers

    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if !self.allComments.isEmpty {
                let comment = self.allComments[self.currentCommentIndex % self.allComments.count]
                self.currentCommentIndex += 1

                self.addCommentAndScroll(comment)
            }
        }
    }

    // MARK: - Internal Methods

    func loadComments() {
        guard let url = Bundle.main.url(forResource: "comments", withExtension: "json") else {
            print("Failed to locate JSON file.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let commentsResponse = try JSONDecoder().decode(CommentsResponse.self, from: data)
            allComments = commentsResponse.comments
            startAutoScroll()
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }

    func addCommentAndScroll(_ comment: Comment) {
        // Add a new comment to the end of the array
        comments.append(comment)

        // Calculate the index path for the new comment
        let newIndexPath = IndexPath(row: comments.count - 1, section: 0)

        // Insert the new row into the table view
        commentsTableView.insertRows(at: [newIndexPath], with: .none)

        // Scroll to the new comment
        self.commentsTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }

    func reset() {
        currentCommentIndex = 0
        timer?.invalidate()
        comments = []
        allComments = []
        commentsTableView.reloadData()
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
