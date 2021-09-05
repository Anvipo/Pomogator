//
//  PoedatorCalculateMealTimeScheduleRestoreInfo.swift
//  App
//
//  Created by Anvipo on 25.01.2023.
//

import Foundation

struct PoedatorCalculateMealTimeScheduleRestoreInfo {
	let numberOfMealTime: UInt?
	let firstMealTime: Date?
	let lastMealTime: Date?
	let shouldAutoDeleteMealSchedule: Bool
}

extension PoedatorCalculateMealTimeScheduleRestoreInfo {
	init(userActivity: NSUserActivity) {
		self.init(
			numberOfMealTime: userActivity.restoredNumberOfMealTimes,
			firstMealTime: userActivity.restoredFirstMealTime,
			lastMealTime: userActivity.restoredLastMealTime,
			shouldAutoDeleteMealSchedule: userActivity.restoredShouldAutoDeleteMealSchedule
		)
	}

	func save(into userActivity: NSUserActivity) {
		userActivity.restoredNumberOfMealTimes = numberOfMealTime
		userActivity.restoredFirstMealTime = firstMealTime
		userActivity.restoredLastMealTime = lastMealTime
		userActivity.restoredShouldAutoDeleteMealSchedule = shouldAutoDeleteMealSchedule
	}
}

private extension String {
	static var restoredNumberOfMealTimesKey: Self {
		"poedator.restoredNumberOfMealTimes"
	}

	static var restoredFirstMealTimeKey: Self {
		"poedator.restoredFirstMealTime"
	}

	static var restoredLastMealTimeKey: Self {
		"poedator.restoredLastMealTime"
	}

	static var restoredShouldAutoDeleteMealScheduleKey: Self {
		"poedator.restoredShouldAutoDeleteMealSchedule"
	}
}

private extension NSUserActivity {
	var restoredNumberOfMealTimes: UInt? {
		get {
			guard let userInfo,
				  let restoredNumberOfMealTimesRawValue = userInfo[String.restoredNumberOfMealTimesKey],
				  let restoredNumberOfMealTimes = restoredNumberOfMealTimesRawValue as? UInt
			else {
				return nil
			}

			return restoredNumberOfMealTimes
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredNumberOfMealTimesKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredNumberOfMealTimesKey: newValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}

	var restoredFirstMealTime: Date? {
		get {
			guard let userInfo,
				  let restoredFirstMealTimeRawValue = userInfo[String.restoredFirstMealTimeKey],
				  let restoredFirstMealTime = restoredFirstMealTimeRawValue as? Date
			else {
				return nil
			}

			return restoredFirstMealTime
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredFirstMealTimeKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredFirstMealTimeKey: newValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}

	var restoredLastMealTime: Date? {
		get {
			guard let userInfo,
				  let restoredLastMealTimeRawValue = userInfo[String.restoredLastMealTimeKey],
				  let restoredLastMealTime = restoredLastMealTimeRawValue as? Date
			else {
				return nil
			}

			return restoredLastMealTime
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredLastMealTimeKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredLastMealTimeKey: newValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}

	var restoredShouldAutoDeleteMealSchedule: Bool {
		get {
			guard let userInfo,
				  let restoredShouldAutoDeleteMealScheduleRawValue = userInfo[String.restoredShouldAutoDeleteMealScheduleKey],
				  let restoredShouldAutoDeleteMealSchedule = restoredShouldAutoDeleteMealScheduleRawValue as? Bool
			else {
				return false
			}

			return restoredShouldAutoDeleteMealSchedule
		}
		set {
			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredShouldAutoDeleteMealScheduleKey: newValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}
}
