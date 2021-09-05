//
//  KeyboardNotification.Name.swift
//  App
//
//  Created by Anvipo on 20.01.2023.
//

import UIKit

extension KeyboardNotification {
	enum Name {
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
		if nsAnalog == UIResponder.keyboardWillShowNotification {
			self = .willShow
		} else if nsAnalog == UIResponder.keyboardDidShowNotification {
			self = .didShow
		} else if nsAnalog == UIResponder.keyboardWillHideNotification {
			self = .willHide
		} else if nsAnalog == UIResponder.keyboardDidHideNotification {
			self = .didHide
		} else if nsAnalog == UIResponder.keyboardWillChangeFrameNotification {
			self = .willChangeFrame
		} else if nsAnalog == UIResponder.keyboardDidChangeFrameNotification {
			self = .didChangeFrame
		} else {
			return nil
		}
	}
}
