//
//  KeyboardNotification.swift
//  App
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

struct KeyboardNotification {
	let animationCurve: UInt

	let animationDuration: TimeInterval

	private let frameBegin: CGRect

	private let frameEnd: CGRect

	let isLocal: Bool

	let screen: UIScreen
}

extension KeyboardNotification {
	var animationOptions: UIView.AnimationOptions {
		UIView.AnimationOptions(rawValue: animationCurve << 16)
	}

	init(notification: Notification) throws {
		guard Name(nsAnalog: notification.name) != nil else {
			let error = MapFromNotificationError.notKeyboardNotification
			assertionFailure(error.localizedDescription)
			throw error
		}

		guard var userInfo = notification.userInfo else {
			let error = MapFromNotificationError.nilUserInfo
			assertionFailure(error.localizedDescription)
			throw error
		}

		if userInfo.isEmpty {
			let error = MapFromNotificationError.emptyUserInfo
			assertionFailure(error.localizedDescription)
			throw error
		}

		guard let frameBegin = userInfo.removeValue(forKey: UIResponder.keyboardFrameBeginUserInfoKey) as? CGRect,
			  let frameEnd = userInfo.removeValue(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? CGRect,
			  let isLocal = userInfo.removeValue(forKey: UIResponder.keyboardIsLocalUserInfoKey) as? Bool,
			  let animationDuration = userInfo.removeValue(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as? TimeInterval,
			  let animationCurve = userInfo.removeValue(forKey: UIResponder.keyboardAnimationCurveUserInfoKey) as? UInt,
			  let screen = notification.object as? UIScreen
		else {
			let error = MapFromNotificationError.wrongTypeInUserInfo
			assertionFailure(error.localizedDescription)
			throw error
		}

		self.init(
			animationCurve: animationCurve,
			animationDuration: animationDuration,
			frameBegin: frameBegin,
			frameEnd: frameEnd,
			isLocal: isLocal,
			screen: screen
		)
	}

	func frameBegin(inCoordinateSpaceOf view: UICoordinateSpace) -> CGRect {
		convert(frameBegin, inCoordinateSpaceOf: view)
	}

	func frameEnd(inCoordinateSpaceOf view: UICoordinateSpace) -> CGRect {
		convert(frameEnd, inCoordinateSpaceOf: view)
	}
}

private extension KeyboardNotification {
	func convert(_ frame: CGRect, inCoordinateSpaceOf view: UICoordinateSpace) -> CGRect {
		// Use that screen to get the coordinate space to convert from.
		let fromCoordinateSpace = screen.coordinateSpace

		// Get your view's coordinate space.
		let toCoordinateSpace: UICoordinateSpace = view

		// Convert the keyboard's frame from the screen's coordinate space to your view's coordinate space.
		return fromCoordinateSpace.convert(frame, to: toCoordinateSpace)
	}
}
