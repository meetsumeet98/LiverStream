import UIKit

class IconTitleView: UIView {

    // MARK: - IBOutlet

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var stackview: UIStackView!

    // MARK: - Properties

    private let stackviewMargins: UIEdgeInsets
    private let iconToTitleSpacing: CGFloat
    private let iconSize: CGSize
    private let icon: UIImage?
    private let title: String

    // MARK: - LifeCycle Methods

    init(icon: UIImage?,
         title: String,
         iconSize: CGSize,
         iconToTitleSpacing: CGFloat = 3,
         padding: UIEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)) {
        self.title = title
        self.icon = icon
        stackviewMargins = padding
        self.iconToTitleSpacing = iconToTitleSpacing
        self.iconSize = iconSize
        super.init(frame: .zero)
        commonInit()
    }

    internal required init?(coder: NSCoder) {
        title = ""
        icon = nil
        stackviewMargins = .zero
        self.iconToTitleSpacing = 0
        iconSize = .zero
        super.init(coder: coder)
    }

    // MARK: - Private Helpers
    
    private func commonInit() {
        // Load the view from the nib file
        let nib = UINib(nibName: "IconTitleView", bundle: Bundle(for: type(of: self)))
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }

        let iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: iconSize.width)
        let iconHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: iconSize.height)
        [iconWidthConstraint, iconHeightConstraint].forEach {
            $0.priority = .required - 1
            $0.isActive = true
        }

        iconImageView.image = icon
        titleLabel.text = title
        stackview.spacing = iconToTitleSpacing
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.layoutMargins = stackviewMargins

        contentView.backgroundColor = .clear
        addSubview(contentView)

        // Disable autoresizing mask to use constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Set constraints to make the contentView fill the entire bounds of this custom view
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
