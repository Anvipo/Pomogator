//
//  BaseAlertController.swift
//  App
//
//  Created by Anvipo on 06.02.2023.
//

import UIKit

@MainActor
class BaseAlertController: UIAlertController {
	@available(*, unavailable)
	override init(nibName: String?, bundle: Bundle?) {
		super.init(nibName: nibName, bundle: bundle)
	}

	// swiftlint:disable unused_parameter
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// swiftlint:enable unused_parameter

	override func viewDidLoad() {
		super.viewDidLoad()
		view.tintColor = ColorStyle.brand.color
	}

	@available(*, unavailable)
	// swiftlint:disable:next unused_parameter
	override func present(_: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
		fatalError("Alert controller should not present any UIViewController")
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
}

extension BaseAlertController {
	static func alert(
		title: String?,
		message: String?,
		actions: [UIAlertAction] = [],
		preferredAction: UIAlertAction? = nil
	) -> Self {
		let title = UIAccessibility.isVoiceOverRunning ? nil : title

		let result = Self(title: title, message: message, preferredStyle: .alert)

		for action in actions {
			result.addAction(action)
		}

		result.preferredAction = preferredAction

		return result
	}
}
