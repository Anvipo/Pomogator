//
//  UserDefaultsFacade.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import Foundation

final class UserDefaultsFacade {
	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
	}
}

// MARK: - Poedator

private extension String {
	static var inputedNumberOfMealTimesKey: Self {
		"inputedNumberOfMealTimes"
	}

	static var inputedFirstMealTimeKey: Self {
		"inputedFirstMealTime"
	}

	static var inputedLastMealTimeKey: Self {
		"inputedLastMealTime"
	}

	static var calculatedMealTimeListKey: Self {
		"calculatedMealTimeList"
	}

	static var areMealTimeRemindersAddedKey: Self {
		"areMealTimeRemindersAdded"
	}
}

extension UserDefaultsFacade {
	var inputedNumberOfMealTimes: UInt? {
		get {
			userDefaults.uint(forKey: .inputedNumberOfMealTimesKey)
		}
		set {
			userDefaults.set(newValue, forKey: .inputedNumberOfMealTimesKey)
		}
	}

	var inputedFirstMealTime: Date? {
		get {
			userDefaults.date(forKey: .inputedFirstMealTimeKey)
		}
		set {
			userDefaults.set(newValue, forKey: .inputedFirstMealTimeKey)
		}
	}

	var inputedLastMealTime: Date? {
		get {
			userDefaults.date(forKey: .inputedLastMealTimeKey)
		}
		set {
			userDefaults.set(newValue, forKey: .inputedLastMealTimeKey)
		}
	}

	var calculatedMealTimeList: [Date] {
		get {
			userDefaults.dates(forKey: .calculatedMealTimeListKey)
		}
		set {
			userDefaults.set(newValue, forKey: .calculatedMealTimeListKey)
		}
	}

	var areMealTimeRemindersAdded: Bool {
		get {
			userDefaults.bool(forKey: .areMealTimeRemindersAddedKey)
		}
		set {
			userDefaults.set(newValue, forKey: .areMealTimeRemindersAddedKey)
		}
	}
}
