import UIKit
import AVFoundation

class VideoCell: UICollectionViewCell {
    static let identifier = "VideoCell"

    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?

    private let topSectionView = TopSectionView()
    private let bottomSectionView = BottomSectionView()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViewHierarchy()
        setupConstraints()
    }

    func setupViewHierarchy() {
        contentView.addSubview(topSectionView)
        contentView.addSubview(bottomSectionView)
    }

    func setupConstraints() {
        topSectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomSectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topSectionView.topAnchor.constraint(equalTo: topAnchor),
            topSectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSectionView.heightAnchor.constraint(equalToConstant: 153),

            bottomSectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSectionView.heightAnchor.constraint(equalToConstant: 333),
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
}
