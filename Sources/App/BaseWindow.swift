//
//  BaseWindow.swift
//  App
//
//  Created by Anvipo on 28.01.2023.
//

import UIKit

@MainActor
class BaseWindow: UIWindow {
	private var tapGestureRecognizerForHidingKeyboard: UITapGestureRecognizer?

	// swiftlint:disable unused_parameter
	@available(*, unavailable)
	override init(frame: CGRect) {
		fatalError("init(frame:) has not been implemented")
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// swiftlint:enable unused_parameter

	override init(windowScene: UIWindowScene) {
		super.init(windowScene: windowScene)
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

extension BaseWindow {
	func addTapGestureRecognizerForHidingKeyboard() {
		assert(!ProcessInfo.processInfo.isiOSAppOnMac)

		let tapGestureRecognizerForHidingKeyboard = UITapGestureRecognizer(
			target: self,
			action: #selector(didTapWindow)
		)
		self.tapGestureRecognizerForHidingKeyboard = tapGestureRecognizerForHidingKeyboard
		tapGestureRecognizerForHidingKeyboard.cancelsTouchesInView = false
		addGestureRecognizer(tapGestureRecognizerForHidingKeyboard)
	}

	func removeTapGestureRecognizerForHidingKeyboard() {
		guard let tapGestureRecognizerForHidingKeyboard else {
			assertionFailure("?")
			return
		}

		removeGestureRecognizer(tapGestureRecognizerForHidingKeyboard)
		self.tapGestureRecognizerForHidingKeyboard = nil
	}
}

private extension BaseWindow {
	@objc
	func didTapWindow() {
		guard let firstResponder else {
			return
		}

		firstResponder.resignFirstResponder()
	}
}
