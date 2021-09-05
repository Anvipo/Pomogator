//
//  PopoverVC.swift
//  App
//
//  Created by Anvipo on 11.02.2023.
//

import UIKit

final class PopoverVC: BaseVC {
	private static var insets: NSDirectionalEdgeInsets {
		.init(horizontalInset: 8, verticalInset: 16)
	}

	private let text: String

	private lazy var backgroundView = UIView()
	private lazy var label = UILabel()

	init(
		sourceView: UIView,
		text: String,
		permittedArrowDirections: [PopoverArrowDirection]
	) {
		self.text = text

		super.init()

		modalPresentationStyle = .popover
		modalTransitionStyle = .crossDissolve

		guard let popoverPresentationController else {
			assertionFailure("?")
			return
		}

		popoverPresentationController.delegate = self
		popoverPresentationController.permittedArrowDirections = permittedArrowDirections.uiKitAnalogs
		popoverPresentationController.sourceItem = sourceView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		if let presentingViewController {
			backgroundView.backgroundColor = .black.withAlphaComponent(0.6)
			backgroundView.alpha = 0

			presentingViewController.view.addSubviewForConstraintsUse(backgroundView)
			NSLayoutConstraint.activate(backgroundView.makeEdgeConstraintsEqualToSuperview())
		}

		view.backgroundColor = ColorStyle.brand.color

		label.numberOfLines = 0
		label.font = FontStyle.body.font
		label.text = text
		label.textAlignment = .center
		label.textColor = ColorStyle.labelOnBrand.color
		label.adjustsFontForContentSizeCategory = true
		label.adjustsFontSizeToFitWidth = true

		view.addSubviewForConstraintsUse(label)
		NSLayoutConstraint.activate(label.makeEdgeConstraintsEqualToSuperviewSafeArea(insets: Self.insets))
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		view.alpha = 0
		popoverPresentationController?.containerView?.alpha = view.alpha

		UIView.animate(duration: animated ? .defaultAnimationDuration : 0) { [weak self] in
			guard let self else {
				return
			}

			view.alpha = 1
			popoverPresentationController?.containerView?.alpha = view.alpha
			backgroundView.alpha = view.alpha
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		func makeViewsTransparent() {
			view.alpha = 0
			popoverPresentationController?.containerView?.alpha = view.alpha
			backgroundView.alpha = view.alpha
		}

		if UIAccessibility.isReduceMotionEnabled && !UIAccessibility.prefersCrossFadeTransitions {
			makeViewsTransparent()
			backgroundView.removeFromSuperview()
			return
		}

		guard let transitionCoordinator else {
			assertionFailure("?")
			makeViewsTransparent()
			backgroundView.removeFromSuperview()
			return
		}

		transitionCoordinator.animate(
			alongsideTransition: { _ in
				makeViewsTransparent()
			},
			completion: { [weak backgroundView] _ in
				backgroundView?.removeFromSuperview()
			}
		)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		preferredContentSize = calculatePreferredContentSize()
	}

	override func handle(
		presses: Set<UIPress>,
		event: UIPressesEvent?,
		superImplementation: HandlePressesClosure
	) {
		guard presses.count == 1,
			  let press = presses.first
		else {
			assertionFailure("?")
			superImplementation(presses, event)
			return
		}

		guard let pressedKey = press.key else {
			superImplementation(presses, event)
			return
		}

		switch pressedKey.keyCode {
		case .keyboardEscape, .keyboardB, .keyboardW:
			if press.phase == .ended && pressedKey.modifierFlags == .command {
				dismiss(animated: shouldAnimate)
			}

		case .keyboardReturnOrEnter:
			if press.phase == .ended {
				dismiss(animated: shouldAnimate)
			}

		default:
			superImplementation(presses, event)
		}
	}
}

extension PopoverVC: UIPopoverPresentationControllerDelegate {
	// swiftlint:disable:next unused_parameter
	func adaptivePresentationStyle(for: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		.none
	}
}

private extension PopoverVC {
	func calculatePreferredContentSize() -> CGSize {
		let width = view.bounds.width
		let height = view.actualContentHeight(availableWidth: width)

		return CGSize(width: width, height: height)
	}
}
