//
//  ParticipantBarView.swift
//  LiverStream
//
//  Created by Sumeet Bhujang on 22/12/24.
//

import UIKit

class ParticipantBarView: UIView {

    // MARK: - Properties

    let commentBoxView = CommentBoxView()
    private let roseButton = ActionButtonView(iconName: "noto_rose", title: "Rose")
    private let giftButton = ActionButtonView(iconName: "noto_wrapped-gift", title: "Gift")
    private let shareButton = ActionButtonView(iconName: "Icon Share", title: "2")

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - LifeCycle Methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViewHierarchy()
        setupViewLayout()
    }

    // MARK: - Private Helpers

    private func setupViewHierarchy() {
        addSubview(commentBoxView)

        stackView.addArrangedSubview(roseButton)
        stackView.addArrangedSubview(giftButton)
        stackView.addArrangedSubview(shareButton)

        addSubview(stackView)
    }

    private func setupViewLayout() {
        commentBoxView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentBoxView.topAnchor.constraint(equalTo: topAnchor),
            commentBoxView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentBoxView.widthAnchor.constraint(equalToConstant: 264),
            commentBoxView.heightAnchor.constraint(equalToConstant: 34),
            commentBoxView.trailingAnchor.constraint(lessThanOrEqualTo: stackView.leadingAnchor),

            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

    }

    // MARK: - Internal Methods

    func setDelegate(_ delegate: CommentBoxViewDelegate) {
        commentBoxView.setDelegate(delegate)
    }

    func backgroundTapped() {
        commentBoxView.backgroundTapped()
    }
}


