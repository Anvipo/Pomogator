//
//  UbiquitousKeyValueStoreDidChangeExternallyNotification.ChangeReason.swift
//  App
//
//  Created by Anvipo on 07.01.2024.
//

import Foundation

extension UbiquitousKeyValueStoreDidChangeExternallyNotification {
	enum ChangeReason {
		case accountChange
		case initialSyncChange
		case quotaViolationChange
		case serverChange
	}
}

extension UbiquitousKeyValueStoreDidChangeExternallyNotification.ChangeReason {
	init?(nsAnalog: Int) {
		if nsAnalog == NSUbiquitousKeyValueStoreServerChange {
			self = .serverChange
		} else if nsAnalog == NSUbiquitousKeyValueStoreInitialSyncChange {
			self = .initialSyncChange
		} else if nsAnalog == NSUbiquitousKeyValueStoreQuotaViolationChange {
			self = .quotaViolationChange
		} else if nsAnalog == NSUbiquitousKeyValueStoreAccountChange {
			self = .accountChange
		} else {
			return nil
		}
	}
}
