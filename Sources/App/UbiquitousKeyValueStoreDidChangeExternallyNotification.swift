//
//  UbiquitousKeyValueStoreDidChangeExternallyNotification.swift
//  App
//
//  Created by Anvipo on 07.01.2024.
//

import Foundation

struct UbiquitousKeyValueStoreDidChangeExternallyNotification {
	let keys: [String]
	let changeReason: ChangeReason
}

extension UbiquitousKeyValueStoreDidChangeExternallyNotification {
	init(notification: Notification) throws {
		guard notification.name == NSUbiquitousKeyValueStore.didChangeExternallyNotification else {
			let error = MapFromNotificationError.notUbiquitousKeyValueStoreNotification
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

		guard let keys = userInfo.removeValue(forKey: NSUbiquitousKeyValueStoreChangedKeysKey) as? [String],
			  let changeReasonInt = userInfo.removeValue(forKey: NSUbiquitousKeyValueStoreChangeReasonKey) as? Int,
			  let changeReason = ChangeReason(nsAnalog: changeReasonInt)
		else {
			let error = MapFromNotificationError.wrongTypeInUserInfo
			assertionFailure(error.localizedDescription)
			throw error
		}

		if userInfo.isNotEmpty {
			assertionFailure("?")
		}

		self.init(keys: keys, changeReason: changeReason)
	}
}
