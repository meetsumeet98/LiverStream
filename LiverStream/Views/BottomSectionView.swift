import UIKit

class BottomSectionView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let participantBarView = ParticipantBarView()
    private let commentsContainerView = CommentsView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViewHierarchy()
        setupGradient()
        setupViewLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViewHierarchy() {
        layer.addSublayer(gradientLayer)
        addSubview(commentsContainerView)
        addSubview(participantBarView)
    }

    func setupViewLayout() {
        participantBarView.translatesAutoresizingMaskIntoConstraints = false
        commentsContainerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
        commentsContainerView.topAnchor.constraint(equalTo: topAnchor),
        commentsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
        commentsContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        commentsContainerView.trailingAnchor.constraint(equalTo: participantBarView.commentBoxView.trailingAnchor),

        participantBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
        participantBarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -34),
        participantBarView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setupGradient() {
         // Set up the bottom gradient (75% -> 50% -> 0% opacity)
        let colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,     // #000000 at 0% opacity
            UIColor.black.withAlphaComponent(0.5).cgColor,    // #000000 at 50% opacity
            UIColor.black.withAlphaComponent(0.75).cgColor   // #000000 at 75% opacity
        ]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)   // Start from top
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)     // End at bottom
    }

    func calculateSafeAreaHeight() -> CGFloat {
        // Get the window or root view controller
        guard let window = UIApplication.shared.windows.first else {
            return 0 // If no window is found, return 0 as fallback
        }

        // Get the safe area insets of the window (includes status bar, notch, etc.)
        let topInset = window.safeAreaInsets.top

        // Alternatively, you can use status bar height for earlier iOS versions (pre-iOS 11)
        let statusBarHeight: CGFloat
        if #available(iOS 13.0, *) {
            statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }

        // Return the calculated top area height (sum of status bar and safe area top inset)
        return max(topInset, statusBarHeight)  // Return the max value of the two (just in case)
    }

    func loadComments() {
        commentsContainerView.loadComments()
    }

    func startAutoScroll() {
        commentsContainerView.startAutoScroll()
    }
}
