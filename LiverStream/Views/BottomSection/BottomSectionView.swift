import Lottie
import UIKit

class BottomSectionView: UIView {

    // MARK: - Properties

    private let gradientLayer = CAGradientLayer()
    private let participantBarView = ParticipantBarView()
    let commentsContainerView = CommentsContainerView()
    private var isAnimating: Bool = false

    private var participateBarViewBottomConstraint: NSLayoutConstraint?

    private lazy var floatingHeartAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "floating-heart-animation")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.alpha = 0
        animationView.isHidden = true
        return animationView
    }()

    // MARK: - Lifecycle Methods

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

    // MARK: - Private Helpers

    private  func setupViewHierarchy() {
        layer.addSublayer(gradientLayer)
        addSubview(commentsContainerView)
        addSubview(participantBarView)
        addSubview(floatingHeartAnimationView)
    }

    private func setupViewLayout() {
        participantBarView.translatesAutoresizingMaskIntoConstraints = false
        commentsContainerView.translatesAutoresizingMaskIntoConstraints = false

        let participateBarViewBottomConstraint = participantBarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        self.participateBarViewBottomConstraint = participateBarViewBottomConstraint
        NSLayoutConstraint.activate([
            commentsContainerView.topAnchor.constraint(equalTo: topAnchor),
            commentsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentsContainerView.bottomAnchor.constraint(equalTo: participantBarView.topAnchor),
            commentsContainerView.trailingAnchor.constraint(equalTo: participantBarView.commentBoxView.trailingAnchor),

            participantBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            participateBarViewBottomConstraint,
            participantBarView.trailingAnchor.constraint(equalTo: trailingAnchor),

            floatingHeartAnimationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            floatingHeartAnimationView.bottomAnchor.constraint(equalTo: participantBarView.topAnchor, constant: -15),
        ])
    }

    private func setupGradient() {
         // Set up the bottom gradient (75% -> 50% -> 0% opacity)
        let colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.black.withAlphaComponent(0.75).cgColor
        ]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }

    private func calculateSafeAreaHeight() -> CGFloat {
        // Get the active window scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }

        return window.safeAreaInsets.bottom
    }

    // MARK: - Internal Methods

    func showFloatingHeartAnimation() {
        guard !isAnimating else { return } // Ignore taps during animation

        isAnimating = true

        floatingHeartAnimationView.alpha = 1
        floatingHeartAnimationView.isHidden = false
        
        floatingHeartAnimationView.play { [weak self] _ in
            self?.floatingHeartAnimationView.alpha = 0
            self?.isAnimating = false
            self?.floatingHeartAnimationView.isHidden = true
        }
    }

    func loadComments() {
        commentsContainerView.loadComments()
    }

    func setDelegate(_ delegate: CommentBoxViewDelegate) {
        participantBarView.setDelegate(delegate)
    }

    func backgroundTapped() {
        participantBarView.backgroundTapped()
    }

    func addCommentAndScroll(_ comment: Comment) {
        commentsContainerView.addCommentAndScroll(comment)
    }

    func addAdditionalPaddingBelowParticipateBar() {
        participateBarViewBottomConstraint?.constant = -12
    }

    func removeAdditionalPaddingBelowParticipateBar() {
        participateBarViewBottomConstraint?.constant = 0
    }
}
