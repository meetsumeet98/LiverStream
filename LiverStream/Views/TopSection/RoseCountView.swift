import UIKit

class RoseCountView: UIView {

    // MARK: - @IBOutlets

    @IBOutlet weak var roseCountLabel: UILabel!
    @IBOutlet weak var timerTextView: UITextView!

    // MARK: - LifeCycle Methods

    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        timerTextView.layer.cornerRadius = 4
        timerTextView.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        timerTextView.clipsToBounds = true
    }

    // MARK: - Private Helpers

    private func commonInit() {
        // Load the view from the nib file
        let nib = UINib(nibName: "RoseCountView", bundle: Bundle(for: type(of: self)))
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }

        addSubview(contentView)
        roseCountLabel.attributedText = createAttributedText(for: "1/5")
        timerTextView.text = "3h 59m"

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topAnchor.constraint(equalTo: contentView.topAnchor),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // Util method to show the yellow & white colored text in a combined fashion per the design spec
    private func createAttributedText(for text: String) -> NSAttributedString {
        // Define the full text (e.g., "1/5" or "11/24")
        let fullText = text

        // Find the range of the text before the "/"
        guard let slashIndex = fullText.firstIndex(of: "/") else {
            return NSAttributedString(string: fullText) // Return plain text if "/" is not found
        }

        // Calculate the ranges
        let beforeSlashRange = NSRange(fullText.startIndex..<slashIndex, in: fullText)
        let afterSlashRange = NSRange(slashIndex..<fullText.endIndex, in: fullText)

        // Create a mutable attributed string
        let attributedString = NSMutableAttributedString(string: fullText)

        // Apply yellow color to the part before "/"
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 1.0, green: 0.717, blue: 0.388, alpha: 1.0), range: beforeSlashRange)

        // Apply default color (e.g., black) to the part after "/"
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: afterSlashRange)

        return attributedString
    }
}
