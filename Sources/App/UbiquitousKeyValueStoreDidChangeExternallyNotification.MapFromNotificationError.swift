//
//  UbiquitousKeyValueStoreDidChangeExternallyNotification.MapFromNotificationError.swift
//  App
//
//  Created by Anvipo on 07.01.2024.
//

import Foundation

extension UbiquitousKeyValueStoreDidChangeExternallyNotification {
	enum MapFromNotificationError {
		case notUbiquitousKeyValueStoreNotification

		case nilUserInfo

		case emptyUserInfo

		case wrongTypeInUserInfo
	}
}

extension UbiquitousKeyValueStoreDidChangeExternallyNotification.MapFromNotificationError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .notUbiquitousKeyValueStoreNotification: "Received notification is not NSUbiquitousKeyValueStore-related"
		case .nilUserInfo: "Notification's user info is nil"
		case .emptyUserInfo: "Notification's user info is empty"
		case .wrongTypeInUserInfo: "User info has wrong type in NSUbiquitousKeyValueStore notification sense"
		}
	}
}
