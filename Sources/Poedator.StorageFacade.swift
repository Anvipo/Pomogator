//
//  Poedator.StorageFacade.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

extension Poedator {
	final class StorageFacade {
		init(userDefaults: UserDefaultsProtocol) {
			self.userDefaults = userDefaults
		}

		private let userDefaults: UserDefaultsProtocol
		private static let calculatedMealTimeListKey = "calculatedMealTimeList"
		private static let areMealTimeRemindersAddedKey = "areMealTimeRemindersAdded"
	}
}

extension Poedator.StorageFacade: PoedatorStorageFacadeInputProtocol {
	func save(calculatedMealTimeList: [Date]) {
		userDefaults.set(
			dates: calculatedMealTimeList,
			forKey: Self.calculatedMealTimeListKey
		)
	}

	func save(areMealTimeRemindersAdded: Bool) {
		userDefaults.set(
			boolean: areMealTimeRemindersAdded,
			forKey: Self.areMealTimeRemindersAddedKey
		)
	}
}

extension Poedator.StorageFacade: PoedatorStorageFacadeOutputProtocol {
	var calculatedMealTimeList: [Date] {
		userDefaults.getDates(forKey: Self.calculatedMealTimeListKey)
	}

	var areMealTimeRemindersAdded: Bool {
		userDefaults.getBoolean(
			forKey: Self.areMealTimeRemindersAddedKey
		)
	}
}
