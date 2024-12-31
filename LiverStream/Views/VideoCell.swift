import AVFoundation
import UIKit

class VideoCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    // MARK: - Constants

    static let identifier = "VideoCell"

    // MARK: - Properties

    private var isKeyboardShown = false
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private let topSectionView = TopSectionView()
    private let bottomSectionView = BottomSectionView()
    private var bottomSectionViewBottomConstraint: NSLayoutConstraint?

    // MARK: - LifeCycle Methods

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.accessibilityIdentifier = "contentViewAccessibilityID"
        setupKeyboardNotifications()
        setupViewHierarchy()
        setupConstraints()
        bottomSectionView.setDelegate(self)
        setupTapHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        bottomSectionView.commentsContainerView.commentsManager.reset()
    }

    // MARK: - Private Helpers

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func setupViewHierarchy() {
        contentView.addSubview(topSectionView)
        contentView.addSubview(bottomSectionView)
    }

    private func setupConstraints() {
        topSectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomSectionView.translatesAutoresizingMaskIntoConstraints = false

        let bottomSectionViewBottomConstraint = bottomSectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        self.bottomSectionViewBottomConstraint = bottomSectionViewBottomConstraint

        NSLayoutConstraint.activate([
            topSectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topSectionView.heightAnchor.constraint(equalToConstant: 153),

            bottomSectionViewBottomConstraint,
            bottomSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomSectionView.heightAnchor.constraint(equalToConstant: 333),
        ])
    }

    @objc
    private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    private func setupTapHandlers() {
        // Single Tap
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.delegate = self
        contentView.addGestureRecognizer(singleTapGesture)

        // Double Tap
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTapGesture)

        // Ensure single tap is recognized only if double tap fails
        singleTapGesture.require(toFail: doubleTapGesture)
    }

    @objc
    private func handleDoubleTap() {
        bottomSectionView.showFloatingHeartAnimation()
    }

    @objc
    private func backgroundTapped() {
        if isKeyboardShown {
            bottomSectionView.backgroundTapped()
        } else {
            player?.rate == 0 ? player?.play() : player?.pause()
        }
    }

    // MARK: - Internal Methods

    func configure(with video: Video) {
        // Configure AVPlayer
        if let url = URL(string: video.video) {
            player = AVPlayer(url: url)
            player?.actionAtItemEnd = .none
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspectFill
            playerLayer?.frame = bounds
            if let playerLayer = playerLayer {
                contentView.layer.insertSublayer(playerLayer, at: 0)
            }
            player?.play()

            // Loop the video
            NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)

            bottomSectionView.loadComments()
        }
    }

    // Temoprary logic to play pause the video when the tap is done on the video part and not on the other controls present on the screen.
    // This logic will be removed once the other controls present on the screen have their own interactions set up.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view?.accessibilityIdentifier == contentView.accessibilityIdentifier || touch.view == bottomSectionView
    }

    func addCommentAndScroll(_ comment: Comment) {
        bottomSectionView.addCommentAndScroll(comment)
    }

    func pauseVideo() {
        player?.pause()
    }

    func playVideo() {
        player?.play()
    }

    // MARK: - Keyboard observers

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        isKeyboardShown = true
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        isKeyboardShown = false
    }
}

// MARK: - CommentBoxViewDelegate

extension VideoCell: CommentBoxViewDelegate {
    func  commentBoxDidBeginEditing(keyboardFrameHeight: CGFloat, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            self.bottomSectionViewBottomConstraint?.constant = -keyboardFrameHeight
            self.bottomSectionView.addAdditionalPaddingBelowParticipateBar()
            self.layoutIfNeeded()
        }
    }

    func commentBoxDidEndEditing(animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            self.bottomSectionViewBottomConstraint?.constant = 0
            self.bottomSectionView.removeAdditionalPaddingBelowParticipateBar()
            self.layoutIfNeeded()
        }
    }
}
