import UIKit

class ActionButtonView: UIStackView {

    // MARK: - Properties

    private let iconImageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()

    // MARK: - LifeCycle Methods

    init(iconName: String, title: String) {
        iconImageView.image = UIImage(named: iconName)
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.text = title
        super.init(frame: .zero)

        axis = .vertical
        alignment = .fill

        addArrangedSubview(iconImageView)
        addArrangedSubview(titleLabel)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 24)
        let iconHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 24)

        [iconWidthConstraint, iconHeightConstraint].forEach { $0.priority = .required - 1 }

        NSLayoutConstraint.activate([
            iconWidthConstraint,
            iconHeightConstraint
        ])
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
