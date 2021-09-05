//
//  ButtonsView.swift
//  App
//
//  Created by Anvipo on 05.11.2021.
//

import UIKit

final class ButtonsView: BaseView {
	private let buttonsStackView: UIStackView
	private let blurredView: BlurredView

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

		super.init()

		setUpConstraints()
		setUpUI()
	}
}

extension ButtonsView {
	func areOtherButtonsHidden(button: Button) -> Bool {
		let otherButtons = buttons.filter { $0 !== button }

		return otherButtons.allSatisfy(\.isHidden)
	}
}

private extension ButtonsView {
	var buttons: [Button] {
		buttonsStackView.arrangedSubviews.compactMap { $0 as? Button }
	}

	func setUpConstraints() {
		addSubviewForConstraintsUse(blurredView)
		NSLayoutConstraint.activate(blurredView.makeEdgeConstraintsEqualToSuperview())

		blurredView.add(subview: buttonsStackView)
	}

	func setUpUI() {
		for view in [blurredView, buttonsStackView] {
			view.layer.cornerRadius = 12
			view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
			view.clipsToBounds = true
		}

		buttonsStackView.spacing = 16
		buttonsStackView.axis = .vertical
		buttonsStackView.directionalLayoutMargins = .init(all: 16)
		buttonsStackView.isLayoutMarginsRelativeArrangement = true
	}
}
