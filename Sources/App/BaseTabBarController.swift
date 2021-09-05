//
//  BaseTabBarController.swift
//  App
//
//  Created by Anvipo on 25.01.2023.
//

import UIKit

@MainActor
class BaseTabBarController: UITabBarController {
	var isViewVisible: Bool

	var shouldAnimate: Bool {
		if UIAccessibility.isReduceMotionEnabled {
			return UIAccessibility.prefersCrossFadeTransitions
		}

		return isViewVisible
	}

	init() {
		isViewVisible = false
		super.init(nibName: nil, bundle: nil)
	}

	// swiftlint:disable unused_parameter
	@available(*, unavailable)
	override init(nibName: String?, bundle: Bundle?) {
		fatalError("init(nibName:bundle:) has not been implemented")
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// swiftlint:enable unused_parameter

	override func viewDidLoad() {
		super.viewDidLoad()
		tabBar.tintColor = ColorStyle.brand.color
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		isViewVisible = true
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		isViewVisible = false
	}

	override func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
		super.present(viewControllerToPresent, animated: animated && shouldAnimate, completion: completion)
	}

	override final func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		handle(touches: touches, event: event, superImplementation: super.touchesBegan(_:with:))
	}

	override final func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		handle(touches: touches, event: event, superImplementation: super.touchesMoved(_:with:))
	}

	override final func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		handle(touches: touches, event: event, superImplementation: super.touchesEnded(_:with:))
	}

	override final func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		handle(touches: touches, event: event, superImplementation: super.touchesCancelled(_:with:))
	}

	func handle(
		touches: Set<UITouch>,
		event: UIEvent?,
		superImplementation: HandleTouchesClosure
	) {
		superImplementation(touches, event)
	}

	override final func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesBegan(_:with:))
	}

	override final func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesChanged(_:with:))
	}

	override final func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesEnded(_:with:))
	}

	override final func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesCancelled(_:with:))
	}

	func handle(
		presses: Set<UIPress>,
		event: UIPressesEvent?,
		superImplementation: HandlePressesClosure
	) {
		superImplementation(presses, event)
	}

	// swiftlint:disable:next unused_parameter
	func traitPreferredContentSizeCategoryDidChange(_ previousTraitCollection: UITraitCollection) {
		// implement
	}
}

extension BaseTabBarController {
	@discardableResult
	func registerForTraitPreferredContentSizeCategoryChanges() -> any UITraitChangeRegistration {
		registerForTraitChanges([UITraitPreferredContentSizeCategory.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
			self.traitPreferredContentSizeCategoryDidChange(previousTraitCollection)
		}
	}
}
