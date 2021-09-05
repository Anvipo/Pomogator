//
//  KeyboardNotification.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

struct KeyboardNotification {
	let animationCurve: UIView.AnimationCurve

	let animationDuration: TimeInterval

	let frameBegin: CGRect

	let frameEnd: CGRect

	let isLocal: Bool
}

extension KeyboardNotification {
	init(notification: Notification) throws {
		if notification.name != UIResponder.keyboardWillShowNotification &&
		   notification.name != UIResponder.keyboardDidShowNotification &&
		   notification.name != UIResponder.keyboardWillHideNotification &&
		   notification.name != UIResponder.keyboardDidHideNotification &&
		   notification.name != UIResponder.keyboardWillChangeFrameNotification &&
		   notification.name != UIResponder.keyboardDidChangeFrameNotification {
			let error = MapFromNotificationError.notKeyboardNotification(notification)
			assertionFailure(error.localizedDescription)
			throw error
		}

		guard var userInfo = notification.userInfo else {
			let error = MapFromNotificationError.nilUserInfo(notification)
			assertionFailure(error.localizedDescription)
			throw error
		}

		if userInfo.isEmpty {
			let error = MapFromNotificationError.emptyUserInfo(notification)
			assertionFailure(error.localizedDescription)
			throw error
		}

		guard let animationCurveNumber = userInfo.removeValue(forKey: UIResponder.keyboardAnimationCurveUserInfoKey) as? Int,
			  let animationCurve = UIView.AnimationCurve(rawValue: animationCurveNumber),
			  let animationDuration = userInfo.removeValue(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as? TimeInterval,
			  let frameBegin = userInfo.removeValue(forKey: UIResponder.keyboardFrameBeginUserInfoKey) as? CGRect,
			  let frameEnd = userInfo.removeValue(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? CGRect,
			  let isLocal = userInfo.removeValue(forKey: UIResponder.keyboardIsLocalUserInfoKey) as? Bool
		else {
			let error = MapFromNotificationError.wrongTypeInUserInfo(notification)
			assertionFailure(error.localizedDescription)
			throw error
		}

		self.init(
			animationCurve: animationCurve,
			animationDuration: animationDuration,
			frameBegin: frameBegin,
			frameEnd: frameEnd,
			isLocal: isLocal
		)
	}
}
