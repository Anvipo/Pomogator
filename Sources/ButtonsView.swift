//
//  ButtonsView.swift
//  Pomogator
//
//  Created by Anvipo on 05.11.2021.
//

import UIKit

final class ButtonsView: UIView {
	private let buttonsStackView: UIStackView
	private let blurredView: BlurredView

	let buttons: [Button]

	init(
		buttons: [Button],
		blurStyle: UIBlurEffect.Style = .systemUltraThinMaterial
	) throws {
		if buttons.isEmpty {
			let error = InitError.emptyButtons
			assertionFailure(error.localizedDescription)
			throw error
		}

		buttonsStackView = UIStackView(arrangedSubviews: buttons)
		blurredView = BlurredView(style: blurStyle)
		self.buttons = buttons

		super.init(frame: .zero)

		setupUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension ButtonsView {
	func setupUI() {
		buttonsStackView.spacing = 16
		buttonsStackView.axis = .vertical
		buttonsStackView.distribution = .equalSpacing
		buttonsStackView.directionalLayoutMargins = .default(verticalInset: 16)
		buttonsStackView.isLayoutMarginsRelativeArrangement = true

		addSubviewForConstraintsUse(blurredView)
		blurredView.addSubviewForConstraintsUse(buttonsStackView)

		NSLayoutConstraint.activate(
			blurredView.makeSameAnchorConstraints(to: self, info: .edgesEqual()) +
			buttonsStackView.makeSameAnchorConstraints(to: blurredView, info: .edgesEqual())
		)
	}
}
