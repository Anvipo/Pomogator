//
//  BlurredView.swift
//  Pomogator
//
//  Created by Anvipo on 30.08.2021.
//

import UIKit

final class BlurredView: UIView {
	private let blurredView: UIVisualEffectView
	private var blurAnimator: UIViewPropertyAnimator?

	init(style: UIBlurEffect.Style?) {
		blurredView = UIVisualEffectView()

		super.init(frame: .zero)

		set(style: style)
		setupUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		blurAnimator?.stopAnimation(true)
	}
}

extension BlurredView {
	func set(style: UIBlurEffect.Style?) {
		if let style {
			blurredView.effect = UIAccessibility.isReduceTransparencyEnabled ? nil : UIBlurEffect(style: style)
		} else {
			blurredView.effect = nil
		}
	}
}

private extension BlurredView {
	func setupUI() {
		blurAnimator = UIViewPropertyAnimator(
			duration: 1,
			curve: .linear
		) { [weak self] in
			self?.blurredView.effect = nil
		}

		blurAnimator?.pausesOnCompletion = true

		for subview in [blurredView] {
			addSubview(subview)
			subview.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate(blurredView.makeSameAnchorConstraints(to: self, info: .edgesEqual()))
	}
}
