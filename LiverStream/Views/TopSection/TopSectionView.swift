import UIKit

class TopSectionView: UIView {

    // MARK: - Properties

    private let topGradientLayer = CAGradientLayer()
    private let cookingIconTitleView = IconTitleView(
        icon: UIImage(named: "star"),
        title: "Cooking",
        iconSize: CGSize(width: 13, height: 13))

    private let viewerCountView = IconTitleView(
        icon: UIImage(named: "mynaui_user-solid"),
        title: "84",
        iconSize: CGSize(width: 13, height: 13),
        iconToTitleSpacing: 0,
        padding: UIEdgeInsets(top: 1, left: 6, bottom: 1, right: 6))

    private let popularLiveIconTitleView = IconTitleView(
        icon: UIImage(named: "noto_star"),
        title: "Popular Live",
        iconSize: CGSize(width: 13, height: 13))

    private let actorView: UIStackView = {
        guard let actorView = Bundle.main.loadNibNamed("ActorView", owner: nil, options: nil)?.first as? UIStackView else {
            print("Could not create exploreView from nib")
            return UIStackView()
        }
        return actorView
    }()

    private let exploreView: UIStackView = {
        guard let exploreView = Bundle.main.loadNibNamed("ExploreView", owner: nil, options: nil)?.first as? UIStackView else {
            print("Could not create exploreView from nib")
            return UIStackView()
        }

        return exploreView
    }()

    private let topControlsStackView = TopControlsStackView()
    private let roseCountView = RoseCountView()

    // MARK: - Lifecycle Methods

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViewHierarchy()
        setupGradient()
        setupViewLayout()
        applyCornerRadiusToExploreView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topGradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Helpers

    private func setupViewHierarchy() {
        layer.addSublayer(topGradientLayer)

        // Left section
        addSubview(actorView)
        addSubview(cookingIconTitleView)
        addSubview(popularLiveIconTitleView)

        // Right section
        addSubview(topControlsStackView)
        addSubview(exploreView)
        addSubview(roseCountView)
    }

    private func setupViewLayout() {
        [actorView, cookingIconTitleView, popularLiveIconTitleView, topControlsStackView, exploreView, roseCountView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            actorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            actorView.topAnchor.constraint(equalTo: topAnchor, constant: topSafeAreaHeight()),

            cookingIconTitleView.topAnchor.constraint(equalTo: actorView.bottomAnchor, constant: 6),
            cookingIconTitleView.leadingAnchor.constraint(equalTo: actorView.leadingAnchor),

            popularLiveIconTitleView.topAnchor.constraint(equalTo: cookingIconTitleView.topAnchor),
            popularLiveIconTitleView.leadingAnchor.constraint(equalTo: cookingIconTitleView.trailingAnchor, constant: 8),

            topControlsStackView.centerYAnchor.constraint(equalTo: actorView.centerYAnchor),
            topControlsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13),

            exploreView.centerYAnchor.constraint(equalTo: cookingIconTitleView.centerYAnchor),
            exploreView.trailingAnchor.constraint(equalTo: trailingAnchor),

            roseCountView.topAnchor.constraint(equalTo: exploreView.bottomAnchor, constant: 10),
            roseCountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13)
        ])
    }

    private func applyCornerRadiusToExploreView() {
        // Need to force layout to be sure that exploreView.bounds are correct
        setNeedsLayout()
        layoutIfNeeded()

        let corners: UIRectCorner = [.topLeft, .bottomLeft]
        let cornerRadius: CGFloat = 12.0

        let path = UIBezierPath(
            roundedRect: exploreView.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )

        // Create a mask layer
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        exploreView.layer.mask = mask
    }

    private func setupGradient() {
        // Set up the top gradient (50% -> 20% -> 0% opacity)
        let topGradientColors = [
            UIColor.black.withAlphaComponent(0.5).cgColor,   // #000000 at 50% opacity
            UIColor.black.withAlphaComponent(0.2).cgColor,   // #000000 at 20% opacity
            UIColor.black.withAlphaComponent(0.0).cgColor    // #000000 at 0% opacity
        ]
        configureGradientLayer(topGradientLayer, with: topGradientColors)
    }

    private func configureGradientLayer(_ gradientLayer: CAGradientLayer, with colors: [CGColor]) {
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)   // Start from top
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)     // End at bottom
    }

    private func topSafeAreaHeight() -> CGFloat {
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
}
