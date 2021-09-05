//
//  PoedatorMealRemindersManager.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import UIKit
@preconcurrency import UserNotifications

// swiftlint:disable:next file_types_order
private extension UNAuthorizationOptions {
	static var applicationAuthorizationOptions: Self {
		[.badge, .sound, .alert, .carPlay]
	}
}

// swiftlint:disable:next file_types_order
private extension String {
	static var notificationRequestIdentifier: Self {
		"Meal reminder notification"
	}
}

@MainActor
final class PoedatorMealRemindersManager {
	private let userNotificationCenterFacade: UserNotificationCenterFacade
	private let calendar: Calendar
	private weak var application: UIApplication?

	init(
		application: UIApplication,
		calendar: Calendar,
		userNotificationCenterFacade: UserNotificationCenterFacade
	) {
		self.application = application
		self.calendar = calendar
		self.userNotificationCenterFacade = userNotificationCenterFacade
	}
}

extension PoedatorMealRemindersManager {
	func clearBadges() {
		guard let application else {
			assertionFailure("?")
			return
		}

		application.clearBadges()
	}

	func removeAllDeliveredNotifications() {
		userNotificationCenterFacade.removeAllDeliveredNotifications()
	}

	func removeAllPendingNotificationRequests() {
		userNotificationCenterFacade.removeAllPendingNotificationRequests()
	}

	func requestUserNotificationAuthorization() async throws -> Bool {
		try await userNotificationCenterFacade.requestAuthorization(authorizationOptions: .applicationAuthorizationOptions)
	}

	func requestToAddMealReminders(for mealTimeList: [Date]) async throws {
		let newTriggers = createTriggers(for: mealTimeList)

		let notificationRequests = await newTriggers
			.enumerated()
			.asyncMap { index, trigger in
				UNNotificationRequest(
					identifier: .notificationRequestIdentifier + " №\(index + 1)",
					content: await createNotificationContent(
						forMealTimeSerialNumber: UInt(index),
						mealTimeListCount: UInt(newTriggers.count)
					),
					trigger: trigger
				)
			}

		for notificationRequest in notificationRequests {
			try await userNotificationCenterFacade.add(notificationRequest: notificationRequest)
		}
	}
}

private extension PoedatorMealRemindersManager {
	func createTriggers(
		for mealTimeList: [Date]
	) -> [UNCalendarNotificationTrigger] {
		mealTimeList.map { mealTime in
			let triggerDate = calendar.dateComponents(
				[.year, .month, .day, .hour, .minute, .second],
				from: mealTime
			)

			return UNCalendarNotificationTrigger(
				dateMatching: triggerDate,
				repeats: false
			)
		}
	}

	func createNotificationContent(
		forMealTimeSerialNumber serialNumber: UInt,
		mealTimeListCount: UInt
	) -> UNNotificationContent {
		let content = UNMutableNotificationContent()

		content.title = String(localized: "Notification from Poedator")
		content.body = createNotificationBody(
			forMealTimeSerialNumber: serialNumber,
			mealTimeListCount: mealTimeListCount
		)
		content.sound = .default

		let badgeValue = (application?.applicationIconBadgeNumber ?? 0) + 1
		// swiftlint:disable:next legacy_objc_type
		content.badge = badgeValue as NSNumber

		return content
	}

	func createNotificationBody(
		forMealTimeSerialNumber mealTimeSerialNumber: UInt,
		mealTimeListCount: UInt
	) -> String {
		if mealTimeListCount == 3 {
			return mealTimeNameFor3MealsADay(
				mealTimeSerialNumber: UInt8(mealTimeSerialNumber)
			)
		}

		if mealTimeListCount == 5 {
			return mealTimeNameFor5MealsADay(
				mealTimeSerialNumber: UInt8(mealTimeSerialNumber)
			)
		}

		return String(localized: "It's time for \(mealTimeSerialNumber + 1)")
	}

	func mealTimeNameFor3MealsADay(
		mealTimeSerialNumber: UInt8
	) -> String {
		switch mealTimeSerialNumber {
		case 0:
			return String(localized: "It's time for breakfast")

		case 1:
			return String(localized: "It's time for lunch")

		case 2:
			return String(localized: "It's time for dinner")

		default:
			assertionFailure("?")
			return ""
		}
	}

	func mealTimeNameFor5MealsADay(
		mealTimeSerialNumber: UInt8
	) -> String {
		switch mealTimeSerialNumber {
		case 0:
			return String(localized: "It's time for breakfast")

		case 1:
			return String(localized: "It's time for second breakfast")

		case 2:
			return String(localized: "It's time for lunch")

		case 3:
			return String(localized: "It's time for afternoon snack")

		case 4:
			return String(localized: "It's time for dinner")

		default:
			assertionFailure("?")
			return ""
		}
	}
}
