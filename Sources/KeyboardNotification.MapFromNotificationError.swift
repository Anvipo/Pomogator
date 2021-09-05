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
		case notKeyboardNotification(Notification)

		case nilUserInfo(Notification)

		case emptyUserInfo(Notification)

		case wrongTypeInUserInfo(Notification)
	}
}

extension KeyboardNotification.MapFromNotificationError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case let .notKeyboardNotification(notification):
			return "Received notification is not keyabord-related. Notification - \(notification)"

		case let .nilUserInfo(notification):
			return "Notification's user info is nil. Notification - \(notification)"

		case let .emptyUserInfo(notification):
			return "Notification's user info is empty. Notification - \(notification)"

		case let .wrongTypeInUserInfo(notification):
			return "User info has wrong type in keyboard notification sense.. Notification - \(notification)"
		}
	}
}
