import UIKit

protocol CommentBoxViewDelegate: AnyObject {
    func commentBoxDidBeginEditing(keyboardFrameHeight: CGFloat, animationDuration: TimeInterval)
    func commentBoxDidEndEditing(animationDuration: TimeInterval)
}

class CommentBoxView: UIView, UITextFieldDelegate {

    weak var delegate: CommentBoxViewDelegate?

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
        commentTextField.delegate = self
        commentTextField.returnKeyType = .send
        setupUI()
        setupKeyboardNotifications()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commentTextField.delegate = self
        setupUI()
        setupKeyboardNotifications()
    }

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

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard commentTextField.isFirstResponder,
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }

        delegate?.commentBoxDidBeginEditing(keyboardFrameHeight: keyboardFrame.height, animationDuration: animationDuration)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }

        delegate?.commentBoxDidEndEditing(animationDuration: animationDuration)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setDelegate(_ delegate: CommentBoxViewDelegate) {
        self.delegate = delegate
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        commentTextField.becomeFirstResponder()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        commentTextField.resignFirstResponder()
    }

    func backgroundTapped() {
        commentTextField.resignFirstResponder()
    }
}

