//
//  KeyboardNotification.MapFromNotificationError.swift
//  Pomogator
//
//  Created by Anvipo on 25.09.2021.
//

import Foundation

// swiftlint:disable:next file_types_order
extension KeyboardNotification {
	enum MapFromNotificationError {
		case notKeyboardNotification

		case nilUserInfo

		case emptyUserInfo

		case wrongTypeInUserInfo
	}
}

extension KeyboardNotification.MapFromNotificationError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .notKeyboardNotification:
			return "Received notification is not keyabord-related"

		case .nilUserInfo:
			return "Notification's user info is nil"

		case .emptyUserInfo:
			return "Notification's user info is empty"

		case .wrongTypeInUserInfo:
			return "User info has wrong type in keyboard notification sense"
		}
	}
}
