//
//  BlurredView.swift
//  App
//
//  Created by Anvipo on 30.08.2021.
//

import UIKit

final class BlurredView: BaseView {
	private let visualEffectView: UIVisualEffectView
	private let style: UIBlurEffect.Style

	init(style: UIBlurEffect.Style) {
		self.style = style
		visualEffectView = UIVisualEffectView(
			effect: UIAccessibility.isReduceTransparencyEnabled ? nil : UIBlurEffect(style: style)
		)

		super.init()

		setUpConstraints()
		setUpUI()
	}
}

extension BlurredView {
	func add(subview: UIView) {
		visualEffectView.contentView.addSubviewForConstraintsUse(subview)
		NSLayoutConstraint.activate(subview.makeEdgeConstraintsEqualToSuperview())
	}
}

private extension BlurredView {
	func setUpConstraints() {
		addSubviewForConstraintsUse(visualEffectView)
		NSLayoutConstraint.activate(visualEffectView.makeEdgeConstraintsEqualToSuperview())
	}

	func setUpUI() {
		observeReduceTransparencyStatusDidChange { [weak self] in
			guard let self else {
				return
			}

			visualEffectView.effect = UIAccessibility.isReduceTransparencyEnabled
			? nil
			: UIBlurEffect(style: style)
		}
	}
}
