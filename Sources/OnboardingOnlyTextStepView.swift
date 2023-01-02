//
//  OnboardingOnlyTextStepView.swift
//  Pomogator
//
//  Created by Anvipo on 04.01.2023.
//

import UIKit

final class OnboardingOnlyTextStepView: UIView {
	private let text: String
	private let screen: UIScreen

	private lazy var textLabel = UILabel()

	init(
		text: String,
		screen: UIScreen
	) {
		self.text = text
		self.screen = screen

		super.init(frame: .zero)

		setupUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension OnboardingOnlyTextStepView {
	func setupUI() {
		textLabel.textAlignment = .center
		textLabel.numberOfLines = 0
		textLabel.text = text
		textLabel.font = Font.title1.uiFont
		textLabel.textColor = Color.labelOnBrand.uiColor

		addSubviewForConstraintsUse(textLabel)
		NSLayoutConstraint.activate(
			textLabel.makeSameAnchorConstraints(
				to: self,
				info: .init(
					leading: .equal(constant: .defaultHorizontalOffset),
					top: .equal(constant: screen.bounds.height / 4),
					trailing: .equal(constant: .defaultHorizontalOffset),
					bottom: .lessThanOrEqual(constant: 64)
				)
			)
		)
	}
}
