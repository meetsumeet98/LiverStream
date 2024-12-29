import UIKit

class TopControlsStackView: UIStackView {
    private let viewerCountView = IconTitleView(
        icon: UIImage(named: "mynaui_user-solid"),
        title: "84",
        iconSize: CGSize(width: 13, height: 13),
        iconToTitleSpacing: 0,
        padding: UIEdgeInsets(top: 1, left: 6, bottom: 1, right: 6))

    private lazy var downArrowView: UIView = {
        let nib = UINib(nibName: "DownArrowView", bundle: Bundle(for: type(of: self)))
        guard let downArrowView = nib.instantiate(withOwner: nil, options: nil).first as? UIView else {
            print("Coudn't get the DownArrowView from XIB")
            return UIView()
        }

        return downArrowView
    }()

    private let closeIconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "iconoir_cancel")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupViewLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViewHierarchy() {
        [viewerCountView, downArrowView, closeIconImageView].forEach { addArrangedSubview($0) }
    }

    func setupViewLayout() {
        axis = .horizontal
        spacing = 6
        alignment = .center

        let closeIconWidthConstraint = closeIconImageView.widthAnchor.constraint(equalToConstant: 18)
        let closeIconHeightConstraint = closeIconImageView.heightAnchor.constraint(equalToConstant: 18)
        [closeIconWidthConstraint, closeIconHeightConstraint].forEach {
            $0.priority = .required - 1
            $0.isActive = true
        }
    }
}
