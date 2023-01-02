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

// MARK: - Onboarding

private extension String {
	static var userWasOnboardedKey: Self {
		"userWasOnboarded"
	}
}

extension UserDefaultsFacade {
	var userWasOnboarded: Bool {
		get {
			userDefaults.bool(forKey: .userWasOnboardedKey)
		}
		set {
			userDefaults.set(
				newValue,
				forKey: .userWasOnboardedKey
			)
		}
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

// MARK: - Vychislyator's daily calorie intake

private extension String {
	static var inputedDailyCalorieIntakeSelectedPersonSexIndexKey: Self {
		"inputedDailyCalorieIntakeSelectedPersonSexIndex"
	}

	static var inputedDailyCalorieIntakeAgeInYearsKey: Self {
		"inputedDailyCalorieIntakeAgeInYears"
	}

	static var inputedDailyCalorieIntakeHeightInCmKey: Self {
		"inputedDailyCalorieIntakeHeightInCm"
	}

	static var inputedDailyCalorieIntakeMassInKgKey: Self {
		"inputedDailyCalorieIntakeMassInKg"
	}

	static var inputedDailyCalorieIntakeSelectedPhysicalActivityIndexKey: Self {
		"inputedDailyCalorieIntakeSelectedPhysicalActivityIndex"
	}

	static var calculatedMifflinStJeorKcNormalValueKey: Self {
		"calculatedMifflinStJeorKcNormalValue"
	}
}

extension UserDefaultsFacade {
	var inputedDailyCalorieIntakeSelectedPersonSexIndex: UInt? {
		get {
			userDefaults.uint(forKey: .inputedDailyCalorieIntakeSelectedPersonSexIndexKey)
		}
		set {
			userDefaults.set(newValue, forKey: .inputedDailyCalorieIntakeSelectedPersonSexIndexKey)
		}
	}

	var inputedDailyCalorieIntakeAgeInYears: UInt? {
		get {
			userDefaults.uint(forKey: .inputedDailyCalorieIntakeAgeInYearsKey)
		}
		set {
			userDefaults.set(newValue, forKey: .inputedDailyCalorieIntakeAgeInYearsKey)
		}
	}

	var inputedDailyCalorieIntakeHeightInCm: Decimal? {
		get {
			userDefaults.decimal(forKey: .inputedDailyCalorieIntakeHeightInCmKey)
		}
		set {
			userDefaults.set(newValue?.nsDecimalNumber, forKey: .inputedDailyCalorieIntakeHeightInCmKey)
		}
	}

	var inputedDailyCalorieIntakeMassInKg: Decimal? {
		get {
			userDefaults.decimal(forKey: .inputedDailyCalorieIntakeMassInKgKey)
		}
		set {
			userDefaults.set(newValue?.nsDecimalNumber, forKey: .inputedDailyCalorieIntakeMassInKgKey)
		}
	}

	var inputedDailyCalorieIntakeSelectedPhysicalActivityIndex: UInt? {
		get {
			userDefaults.uint(forKey: .inputedDailyCalorieIntakeSelectedPhysicalActivityIndexKey)
		}
		set {
			userDefaults.set(newValue, forKey: .inputedDailyCalorieIntakeSelectedPhysicalActivityIndexKey)
		}
	}

	var calculatedMifflinStJeorKcNormalValue: Decimal? {
		get {
			userDefaults.decimal(forKey: .calculatedMifflinStJeorKcNormalValueKey)
		}
		set {
			userDefaults.set(newValue?.nsDecimalNumber, forKey: .calculatedMifflinStJeorKcNormalValueKey)
		}
	}
}

// MARK: - Vychislyator's body mass index

private extension String {
	static var inputedBodyMassIndexMassInKgKey: Self {
		"inputedBodyMassIndexMassInKg"
	}

	static var inputedBodyMassIndexHeightInCmKey: Self {
		"inputedBodyMassIndexHeightInCm"
	}

	static var calculatedBodyMassIndexKey: Self {
		"calculatedBodyMassIndex"
	}
}

extension UserDefaultsFacade {
	var inputedBodyMassIndexMassInKg: Decimal? {
		get {
			userDefaults.decimal(forKey: .inputedBodyMassIndexMassInKgKey)
		}
		set {
			userDefaults.set(newValue?.nsDecimalNumber, forKey: .inputedBodyMassIndexMassInKgKey)
		}
	}

	var inputedBodyMassIndexHeightInCm: Decimal? {
		get {
			userDefaults.decimal(forKey: .inputedBodyMassIndexHeightInCmKey)
		}
		set {
			userDefaults.set(newValue?.nsDecimalNumber, forKey: .inputedBodyMassIndexHeightInCmKey)
		}
	}

	var calculatedBodyMassIndex: Decimal? {
		get {
			userDefaults.decimal(forKey: .calculatedBodyMassIndexKey)
		}
		set {
			userDefaults.set(newValue?.nsDecimalNumber, forKey: .calculatedBodyMassIndexKey)
		}
	}
}
