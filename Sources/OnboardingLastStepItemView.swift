//
//  OnboardingLastStepItemView.swift
//  Pomogator
//
//  Created by Anvipo on 07.01.2023.
//

import UIKit

// swiftlint:disable:next file_types_order
extension OnboardingLastStepItemView {
	struct Model {
		let icon: Image
		let title: String
		let text: String
	}
}

final class OnboardingLastStepItemView: UIView {
	private let iconImageView: UIImageView
	private let titleLabel: UILabel
	private let textLabel: UILabel

	private let insets: NSDirectionalEdgeInsets

	init(
		model: Model,
		insets: NSDirectionalEdgeInsets
	) {
		iconImageView = UIImageView(image: model.icon.uiImage)

		titleLabel = UILabel()
		titleLabel.text = model.title

		textLabel = UILabel()
		textLabel.text = model.text

		self.insets = insets

		super.init(frame: .zero)

		setupUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension OnboardingLastStepItemView {
	func setupUI() {
		iconImageView.tintColor = Color.white.uiColor

		titleLabel.font = Font.title1.uiFont
		titleLabel.numberOfLines = 0
		titleLabel.textColor = Color.white.uiColor

		textLabel.font = Font.body.uiFont
		textLabel.numberOfLines = 0
		textLabel.textColor = Color.white.uiColor

		let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, textLabel])
		labelsStackView.axis = .vertical
		labelsStackView.spacing = .defaultVerticalOffset

		let commonStackView = UIStackView(arrangedSubviews: [iconImageView, labelsStackView])
		commonStackView.spacing = .defaultVerticalOffset * 2
		commonStackView.alignment = .center

		addSubviewForConstraintsUse(commonStackView)

		NSLayoutConstraint.activate([
			iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
			iconImageView.heightAnchor.constraint(equalToConstant: 45)
		] + commonStackView.makeSameAnchorConstraints(to: self, info: .edgesEqual(insets: insets)))
	}
}
