import UIKit

class IconTitleView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var stackview: UIStackView!

    private let stackviewMargins: UIEdgeInsets
    private let iconToTitleSpacing: CGFloat
    private let iconSize: CGSize

    init(icon: UIImage?,
         title: String,
         iconSize: CGSize,
         iconToTitleSpacing: CGFloat = 3,
         padding: UIEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)) {
        stackviewMargins = padding
        self.iconToTitleSpacing = iconToTitleSpacing
        self.iconSize = iconSize
        super.init(frame: .zero)
        commonInit()
    }

    internal required init?(coder: NSCoder) {
        stackviewMargins = .zero
        self.iconToTitleSpacing = 0
        iconSize = .zero
        super.init(coder: coder)
    }

    private func commonInit() {
        // Load the view from the nib file
        let nib = UINib(nibName: "IconTitleView", bundle: Bundle(for: type(of: self)))
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }

//        iconImageView.image = UIImage(named: "star-comment-alt_9291731 3")
//        titleLabel.text = "Cooking"

//                iconImageView.image = UIImage(named: "noto_star")
//                titleLabel.text = "Popular Live"

        let iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: iconSize.width)
        let iconHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: iconSize.height)
        [iconWidthConstraint, iconHeightConstraint].forEach {
            $0.priority = .required - 1
            $0.isActive = true
        }

        iconImageView.image = UIImage(named: "mynaui_user-solid")
        titleLabel.text = "84"
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
