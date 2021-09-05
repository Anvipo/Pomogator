//
//  BaseView.swift
//  App
//
//  Created by Anvipo on 30.01.2023.
//

import UIKit

@MainActor
class BaseView: UIView {
	var tasks: [AnyTask]

	var shouldAnimate: Bool {
		if UIAccessibility.isReduceMotionEnabled {
			return UIAccessibility.prefersCrossFadeTransitions
		}

		return isAddedToWindow
	}

	init() {
		tasks = []

		super.init(frame: .zero)
	}

	override init(frame: CGRect) {
		tasks = []

		super.init(frame: frame)
	}

	// swiftlint:disable unused_parameter
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// swiftlint:enable unused_parameter

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

extension BaseView {
	var defaultAnimationDuration: TimeInterval {
		if !shouldAnimate {
			return 0
		}

		return .defaultAnimationDuration
	}

	func observeReduceTransparencyStatusDidChange(
		onReceiveNotification: @escaping OnReceiveAccessibilityNotification
	) {
		let task = Task { [weak notificationCenter] in
			await notificationCenter?.didChangeReduceTransparencyStatusNotifications(
				onReceiveNotification: onReceiveNotification
			)
		}

		tasks.append(task)
	}

	@discardableResult
	func registerForTraitPreferredContentSizeCategoryChanges() -> any UITraitChangeRegistration {
		registerForTraitChanges([UITraitPreferredContentSizeCategory.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
			self.traitPreferredContentSizeCategoryDidChange(previousTraitCollection)
		}
	}
}

private extension BaseView {
	var notificationCenter: NotificationCenter {
		.default
	}
}
