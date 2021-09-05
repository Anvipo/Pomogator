//
//  KeyboardNotification.MapFromNotificationError.swift
//  App
//
//  Created by Anvipo on 25.09.2021.
//

import Foundation

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
		case .notKeyboardNotification: "Received notification is not keyabord-related"
		case .nilUserInfo: "Notification's user info is nil"
		case .emptyUserInfo: "Notification's user info is empty"
		case .wrongTypeInUserInfo: "User info has wrong type in keyboard notification sense"
		}
	}
}
