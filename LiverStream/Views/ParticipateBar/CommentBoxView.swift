import UIKit

class CommentBoxView: UIView {

    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.tintColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Comment",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )

        textField.font = UIFont.systemFont(ofSize: 12)
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let smileyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mdi_emoji-outline")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 0.4)
        layer.cornerRadius = 21
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(commentTextField)
        addSubview(smileyIcon)

        // Constraints
        NSLayoutConstraint.activate([
            // TextField
            commentTextField.topAnchor.constraint(equalTo: topAnchor),
            commentTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            commentTextField.trailingAnchor.constraint(equalTo: smileyIcon.leadingAnchor),
            commentTextField.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Smiley icon
            smileyIcon.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor),
            smileyIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
            smileyIcon.widthAnchor.constraint(equalToConstant: 18),
            smileyIcon.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
}

