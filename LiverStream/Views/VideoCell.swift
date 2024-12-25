import UIKit
import AVFoundation

class VideoCell: UICollectionViewCell {
    static let identifier = "VideoCell"

    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?

    private let cookingIconTitleView = IconTitleView(
        icon: UIImage(named: "mynaui_user-solid"),
        title: "84",
        iconSize: CGSize(width: 13, height: 13),
        iconToTitleSpacing: 0,
        padding: UIEdgeInsets(top: 1, left: 6, bottom: 1, right: 6))

    private let actorView: UIStackView = {
        guard let actorView = Bundle.main.loadNibNamed("ActorView", owner: nil, options: nil)?.first as? UIStackView else {
            print("Could not create ActorView from nib")
            return UIStackView()
        }
        return actorView
    }()


    private let participantBarView = ParticipantBarView()
    private let commentsContainerView = CommentsView()
    private let topGradientView = UIView()
    private let topGradientLayer = CAGradientLayer()

    private let bottomGradientView = UIView()
    private let bottomGradientLayer = CAGradientLayer()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViewHierarchy()
        setupGradient()
        setupConstraints()
    }

    func setupViewHierarchy() {
        topGradientView.layer.addSublayer(topGradientLayer)
        bottomGradientView.layer.addSublayer(bottomGradientLayer)

        topGradientView.addSubview(actorView)
        bottomGradientView.addSubview(commentsContainerView)

        contentView.addSubview(topGradientView)
        contentView.addSubview(bottomGradientView)

        bottomGradientView.addSubview(participantBarView)
    }

    func setupConstraints() {
        topGradientView.translatesAutoresizingMaskIntoConstraints = false
        bottomGradientView.translatesAutoresizingMaskIntoConstraints = false
        participantBarView.translatesAutoresizingMaskIntoConstraints = false
        commentsContainerView.translatesAutoresizingMaskIntoConstraints = false
        actorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            actorView.centerXAnchor.constraint(equalTo: topGradientView.centerXAnchor),
            actorView.centerYAnchor.constraint(equalTo: topGradientView.centerYAnchor),

            topGradientView.topAnchor.constraint(equalTo: topAnchor),
            topGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topGradientView.heightAnchor.constraint(equalToConstant: 153),

            commentsContainerView.topAnchor.constraint(equalTo: bottomGradientView.topAnchor),
            commentsContainerView.leadingAnchor.constraint(equalTo: bottomGradientView.leadingAnchor),
            commentsContainerView.bottomAnchor.constraint(equalTo: bottomGradientView.bottomAnchor),
            commentsContainerView.trailingAnchor.constraint(equalTo: participantBarView.commentBoxView.trailingAnchor),

            bottomGradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomGradientView.heightAnchor.constraint(equalToConstant: 333),

            participantBarView.leadingAnchor.constraint(equalTo: bottomGradientView.leadingAnchor, constant: 13),
            participantBarView.bottomAnchor.constraint(equalTo: bottomGradientView.safeAreaLayoutGuide.bottomAnchor, constant: -34),
            participantBarView.trailingAnchor.constraint(equalTo: bottomGradientView.trailingAnchor)
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

            commentsContainerView.loadComments()
            commentsContainerView.startAutoScroll()
            
        }
    }

    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
        topGradientLayer.frame = contentView.bounds
        bottomGradientLayer.frame = contentView.bounds
    }

    func setupGradient() {
        // Set up the top gradient (50% -> 20% -> 0% opacity)
        let topGradientColors = [
            UIColor.black.withAlphaComponent(0.5).cgColor,   // #000000 at 50% opacity
            UIColor.black.withAlphaComponent(0.2).cgColor,   // #000000 at 20% opacity
            UIColor.black.withAlphaComponent(0.0).cgColor    // #000000 at 0% opacity
        ]
        configureGradientLayer(topGradientLayer, with: topGradientColors)

        // Set up the bottom gradient (75% -> 50% -> 0% opacity)
        let bottomGradientColors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,     // #000000 at 0% opacity
            UIColor.black.withAlphaComponent(0.5).cgColor,    // #000000 at 50% opacity
            UIColor.black.withAlphaComponent(0.75).cgColor   // #000000 at 75% opacity
        ]
        configureGradientLayer(bottomGradientLayer, with: bottomGradientColors)
    }

    // Function to add gradient to a view
    func configureGradientLayer(_ gradientLayer: CAGradientLayer, with colors: [CGColor]) {
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)   // Start from top
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)     // End at bottom
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
}
