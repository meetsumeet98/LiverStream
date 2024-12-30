import UIKit

protocol CommentsManagerDelegate: NSObjectProtocol {
    func scrollViewDidScroll()
}

class CommentsManager: NSObject, UITableViewDataSource, UITableViewDelegate {

    private var comments: [Comment] = []
    let commentsTableView: UITableView

    weak var delegate: CommentsManagerDelegate?

    init(withCommentsTableView commentsTableView: UITableView) {
        self.commentsTableView = commentsTableView
    }

    private var timer: Timer?

    private var currentCommentIndex = 0

    deinit {
        timer?.invalidate() // Stop the timer
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

    func addComment(_ comment: Comment) {
        // Update the data source
        comments.append(comment)

        // Calculate the index path for the new comment
        let newIndexPath = IndexPath(row: comments.count - 1, section: 0)

        // Insert the new row into the table view
        commentsTableView.insertRows(at: [newIndexPath], with: .automatic)

        // Optionally scroll to the new comment
        commentsTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll()
    }
}
