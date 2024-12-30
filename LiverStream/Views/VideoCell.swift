import UIKit
import AVFoundation
import Lottie

class VideoCell: UICollectionViewCell, CommentBoxViewDelegate {

    func  commentBoxDidBeginEditing(keyboardFrameHeight: CGFloat, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            self.bottomSectionViewBottomConstraint?.constant = -keyboardFrameHeight
            self.layoutIfNeeded()
        }
    }
    
    func commentBoxDidEndEditing(animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            self.bottomSectionViewBottomConstraint?.constant = 0
            self.layoutIfNeeded()
        }
    }

    private lazy var floatingHeartAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "floating-heart-animation")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.alpha = 0
        return animationView
    }()

    static let identifier = "VideoCell"

    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?

    private let topSectionView = TopSectionView()
    private let bottomSectionView = BottomSectionView()

    private var bottomSectionViewBottomConstraint: NSLayoutConstraint?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViewHierarchy()
        setupConstraints()
        bottomSectionView.setDelegate(self)
        setupTapHandlers()
    }

    func setupViewHierarchy() {
        contentView.addSubview(topSectionView)
        contentView.addSubview(bottomSectionView)
        contentView.addSubview(floatingHeartAnimationView)
    }

    func setupConstraints() {
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

            floatingHeartAnimationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            floatingHeartAnimationView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configure(with video: Video) {
        // Configure AVPlayer
        if let url = URL(string: video.video) {
            player = AVPlayer(url: url)
            player?.actionAtItemEnd = .none
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspectFill
            if let playerLayer = playerLayer {
                contentView.layer.insertSublayer(playerLayer, at: 0)
            }
            player?.play()

            // Loop the video
            NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)

            bottomSectionView.loadComments()
            bottomSectionView.startAutoScroll()
        }
    }

    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }

    func setupTapHandlers() {
        // Single Tap
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        singleTapGesture.numberOfTapsRequired = 1
        self.contentView.addGestureRecognizer(singleTapGesture)

        // Double Tap
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.contentView.addGestureRecognizer(doubleTapGesture)

        // Ensure single tap is recognized only if double tap fails
        singleTapGesture.require(toFail: doubleTapGesture)
    }

    @objc func handleDoubleTap() {
        floatingHeartAnimationView.alpha = 1
        floatingHeartAnimationView.play { [weak self] _ in
            // Fade out the animation after playing
            UIView.animate(withDuration: 0.5) {
                self?.floatingHeartAnimationView.alpha = 0
            }
        }
    }

    @objc
    func backgroundTapped() {
        bottomSectionView.backgroundTapped()
    }

    func addComment(_ comment: Comment) {
        bottomSectionView.addComment(comment)
    }
}
