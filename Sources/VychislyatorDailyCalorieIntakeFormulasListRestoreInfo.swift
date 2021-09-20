//
//  VychislyatorDailyCalorieIntakeFormulasListRestoreInfo.swift
//  Pomogator
//
//  Created by Anvipo on 26.01.2023.
//

import Foundation

struct VychislyatorDailyCalorieIntakeFormulasListRestoreInfo {
	let personSex: PersonSex
	let ageInYears: UInt?
	let heightInCm: Decimal?
	let massInKg: Decimal?
	let physicalActivity: PhysicalActivity
}

extension VychislyatorDailyCalorieIntakeFormulasListRestoreInfo: IRestoreInfo {
	init(userActivity: NSUserActivity) {
		self.init(
			personSex: userActivity.restoredPersonSex ?? .male,
			ageInYears: userActivity.restoredAgeInYears,
			heightInCm: userActivity.restoredHeightInCm,
			massInKg: userActivity.restoredMassInKg,
			physicalActivity: userActivity.restoredPhysicalActivity ?? .low
		)
	}

	func save(into userActivity: NSUserActivity) {
		userActivity.restoredPersonSex = personSex
		userActivity.restoredAgeInYears = ageInYears
		userActivity.restoredHeightInCm = heightInCm
		userActivity.restoredMassInKg = massInKg
		userActivity.restoredPhysicalActivity = physicalActivity
	}
}

private extension String {
	static var restoredPersonSexKey: Self {
		"vychislyator.dailyCalorieIntake.personSex"
	}

	static var restoredAgeInYearsKey: Self {
		"vychislyator.dailyCalorieIntake.ageInYears"
	}

	static var restoredHeightInCmKey: Self {
		"vychislyator.dailyCalorieIntake.heightInCm"
	}

	static var restoredMassInKgKey: Self {
		"vychislyator.dailyCalorieIntake.massInKg"
	}

	static var restoredPhysicalActivityKey: Self {
		"vychislyator.dailyCalorieIntake.physicalActivity"
	}
}

private extension NSUserActivity {
	var restoredPersonSex: PersonSex? {
		get {
			guard let userInfo,
				  let restoredPersonSexRawValue = userInfo[String.restoredPersonSexKey] as? PersonSex.RawValue,
				  let restoredPersonSex = PersonSex(rawValue: restoredPersonSexRawValue)
			else {
				return nil
			}

			return restoredPersonSex
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredPersonSexKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredPersonSexKey: newValue.rawValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}

	var restoredAgeInYears: UInt? {
		get {
			guard let userInfo,
				  let restoredAgeInYearsRawValue = userInfo[String.restoredAgeInYearsKey],
				  let restoredAgeInYears = restoredAgeInYearsRawValue as? UInt
			else {
				return nil
			}

			return restoredAgeInYears
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredAgeInYearsKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredAgeInYearsKey: newValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}

	var restoredHeightInCm: Decimal? {
		get {
			guard let userInfo,
				  let restoredHeightInCmRawValue = userInfo[String.restoredHeightInCmKey],
				  let restoredHeightInCm = restoredHeightInCmRawValue as? Decimal
			else {
				return nil
			}

			return restoredHeightInCm
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredHeightInCmKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredHeightInCmKey: newValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}

	var restoredMassInKg: Decimal? {
		get {
			guard let userInfo,
				  let restoredMassInKgRawValue = userInfo[String.restoredMassInKgKey],
				  let restoredMassInKg = restoredMassInKgRawValue as? Decimal
			else {
				return nil
			}

			return restoredMassInKg
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredMassInKgKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredMassInKgKey: newValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}

	var restoredPhysicalActivity: PhysicalActivity? {
		get {
			guard let userInfo,
				  let restoredPhysicalActivityRawValue = userInfo[String.restoredPhysicalActivityKey] as? PhysicalActivity.RawValue,
				  let restoredPhysicalActivity = PhysicalActivity(rawValue: restoredPhysicalActivityRawValue)
			else {
				return nil
			}

			return restoredPhysicalActivity
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredPhysicalActivityKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredPhysicalActivityKey: newValue.rawValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}
}
