//
//  OnboardingView.swift
//  PerfectWeather
//
//  Created by Artem Sviridov on 22.04.2023.
//

import UIKit

protocol OnboardingViewProtocol: UIView { }

protocol OnboardingViewDelegate: AnyObject {
    func didTapButton(_ hasAccess: Bool)
}

final class OnboardingView: UIView, OnboardingViewProtocol {
    weak var delegate: OnboardingViewDelegate?

    private let appearance = Appearance()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var image: UIImageView = {
        let imageView = UIImageView(image: appearance.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = appearance.title
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: appearance.fontSize16, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.text = appearance.subtitle
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: appearance.fontSize14)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()

    private lazy var extratitle: UILabel = {
        let label = UILabel()
        label.text = appearance.extratitle
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: appearance.fontSize14)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()

    private lazy var agreeButton: UIButton = {
        let button = UIButton()
        let attributedString = NSAttributedString(
            string: appearance.agreeButtonTitle,
            attributes: [
                .font: appearance.agreeButtonFont,
            ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = appearance.agreeButtonBackgroundColor
        button.clipsToBounds = true
        button.layer.cornerRadius = appearance.agreeButtonCornerRadius
        button.heightAnchor.constraint(equalToConstant: appearance.agreeButtonHeight).isActive = true
        button.addTarget(self, action: #selector(agreeButtonAction), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        let attributedString = NSAttributedString(
            string: appearance.cancelButtonTitle,
            attributes: [
                .font: appearance.cancelButtonFont,
            ]
        )
        button.setTitleColor(.red, for: .selected)
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.heightAnchor.constraint(equalToConstant: appearance.cancelButtonHeight).isActive = true
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()

    private lazy var subtitlesContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = appearance.subtitlesSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var buttonsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = appearance.buttonsSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.widthAnchor.constraint(equalToConstant: appearance.buttonsWidth).isActive = true
        return stack
    }()

    required init(delegate: OnboardingViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)

        backgroundColor = appearance.accentColor
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private

private extension OnboardingView {
    struct Appearance {
        let accentColor = UIColor(named: "AccentColor")

        let fontSize14: CGFloat = 14
        let fontSize16: CGFloat = 16

        let image = UIImage(named: "LadyWithUmbrella")
        let imageWidth: CGFloat = 180
        let imageHeight: CGFloat = 196

        let subtitle = "Чтобы получить более точные прогнозы\nпогоды во время движения или путешествия"
        let extratitle = "Вы можете изменить свой выбор в любое\nвремя из меню приложения"

        let title = "Разрешить приложению Weather\nиспользовать данные\nо местоположении вашего устройства"
        let titleWidth: CGFloat = 322
        let titleTopIndent: CGFloat = 56

        let subtitlesWidth: CGFloat = 314
        let subtitlesTopIndent: CGFloat = 56
        let subtitlesSpacing: CGFloat = 14

        let buttonsWidth: CGFloat = 340
        let buttonsTopIndent: CGFloat = 42
        let buttonsSpacing: CGFloat = 25

        let cancelButtonTitle = "НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ"
        let cancelButtonHeight: CGFloat = 21
        let cancelButtonFont: UIFont = .systemFont(ofSize: 16, weight: .regular)

        let agreeButtonBackgroundColor = UIColor(named: "ButtonColor")
        let agreeButtonTitle = "ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ  УСТРОЙСТВА"
        let agreeButtonFont: UIFont = .systemFont(ofSize: 12, weight: .medium)
        let agreeButtonCornerRadius: CGFloat = 10
        let agreeButtonHeight: CGFloat = 40
    }

    func addSubviews() {
        addSubview(containerView)
        [image, title, subtitlesContainer, buttonsContainer].forEach { containerView.addSubview($0) }
        [subtitle, extratitle].forEach { subtitlesContainer.addArrangedSubview($0) }
        [agreeButton, cancelButton].forEach { buttonsContainer.addArrangedSubview($0) }
    }

    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),

            image.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            image.topAnchor.constraint(equalTo: containerView.topAnchor),
            image.heightAnchor.constraint(equalToConstant: appearance.imageHeight),
            image.widthAnchor.constraint(equalToConstant: appearance.imageWidth),

            title.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            title.widthAnchor.constraint(equalToConstant: appearance.titleWidth),
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: appearance.titleTopIndent),

            subtitlesContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subtitlesContainer.widthAnchor.constraint(equalToConstant: appearance.subtitlesWidth),
            subtitlesContainer.topAnchor.constraint(
                equalTo: title.bottomAnchor,
                constant: appearance.subtitlesTopIndent
            ),

            buttonsContainer.topAnchor.constraint(
                equalTo: subtitlesContainer.bottomAnchor,
                constant: appearance.buttonsTopIndent
            ),
            buttonsContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            buttonsContainer.widthAnchor.constraint(equalToConstant: appearance.buttonsWidth),
            buttonsContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }

    @objc
    func cancelButtonAction() {
        delegate?.didTapButton(false)
    }

    @objc
    func agreeButtonAction() {
        delegate?.didTapButton(true)
    }
}
