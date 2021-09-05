//
//  KeyboardNotification.Name.swift
//  Pomogator
//
//  Created by Anvipo on 20.01.2023.
//

import UIKit

// swiftlint:disable:next file_types_order
extension KeyboardNotification {
	@MainActor
	enum Name: Sendable {
		case willShow
		case didShow

		case willHide
		case didHide

		case willChangeFrame
		case didChangeFrame
	}
}

extension KeyboardNotification.Name {
	init?(nsAnalog: Notification.Name) {
		switch nsAnalog {
		case UIResponder.keyboardWillShowNotification:
			self = .willShow

		case UIResponder.keyboardDidShowNotification:
			self = .didShow

		case UIResponder.keyboardWillHideNotification:
			self = .willHide

		case UIResponder.keyboardDidHideNotification:
			self = .didHide

		case UIResponder.keyboardWillChangeFrameNotification:
			self = .willChangeFrame

		case UIResponder.keyboardDidChangeFrameNotification:
			self = .didChangeFrame

		default:
			return nil
		}
	}
}
