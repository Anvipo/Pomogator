//
//  VychislyatorDailyCalorieIntakeUserDefaultsFacade.swift
//  Pomogator
//
//  Created by Anvipo on 24.01.2023.
//

import Foundation

final class VychislyatorDailyCalorieIntakeUserDefaultsFacade {
	private let userDefaultsFacade: UserDefaultsFacade

	init(userDefaultsFacade: UserDefaultsFacade) {
		self.userDefaultsFacade = userDefaultsFacade
	}
}

extension VychislyatorDailyCalorieIntakeUserDefaultsFacade {
	var selectedPersonSexIndex: UInt? {
		get {
			userDefaultsFacade.local.uint(forKey: .selectedPersonSexIndexKey)
		}
		set {
			userDefaultsFacade.local.set(newValue, forKey: .selectedPersonSexIndexKey)
		}
	}

	var ageInYears: UInt? {
		get {
			userDefaultsFacade.local.uint(forKey: .ageInYearsKey)
		}
		set {
			userDefaultsFacade.local.set(newValue, forKey: .ageInYearsKey)
		}
	}

	var heightInCm: Decimal? {
		get {
			userDefaultsFacade.local.decimal(forKey: .heightInCmKey)
		}
		set {
			userDefaultsFacade.local.set(newValue?.nsDecimalNumber, forKey: .heightInCmKey)
		}
	}

	var massInKg: Decimal? {
		get {
			userDefaultsFacade.local.decimal(forKey: .massInKgKey)
		}
		set {
			userDefaultsFacade.local.set(newValue?.nsDecimalNumber, forKey: .massInKgKey)
		}
	}

	var selectedPhysicalActivityIndex: UInt? {
		get {
			userDefaultsFacade.local.uint(forKey: .selectedPhysicalActivityIndexKey)
		}
		set {
			userDefaultsFacade.local.set(newValue, forKey: .selectedPhysicalActivityIndexKey)
		}
	}

	var mifflinStJeorKcNormalValue: Decimal? {
		get {
			userDefaultsFacade.shared.decimal(forKey: .mifflinStJeorKcNormalValueKey)
		}
		set {
			userDefaultsFacade.shared.set(newValue?.nsDecimalNumber, forKey: .mifflinStJeorKcNormalValueKey)
		}
	}
}

private extension String {
	static var selectedPersonSexIndexKey: Self {
		"vychislyator.dailyCalorieIntake.selectedPersonSexIndex"
	}

	static var ageInYearsKey: Self {
		"vychislyator.dailyCalorieIntake.ageInYears"
	}

	static var heightInCmKey: Self {
		"vychislyator.dailyCalorieIntake.heightInCm"
	}

	static var massInKgKey: Self {
		"vychislyator.dailyCalorieIntake.massInKg"
	}

	static var selectedPhysicalActivityIndexKey: Self {
		"vychislyator.dailyCalorieIntake.selectedPhysicalActivityIndex"
	}

	static var mifflinStJeorKcNormalValueKey: Self {
		"vychislyator.dailyCalorieIntake.mifflinStJeorKcNormalValue"
	}
}
