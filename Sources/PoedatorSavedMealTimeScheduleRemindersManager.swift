//
//  PoedatorSavedMealTimeScheduleRemindersManager.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import UIKit
@preconcurrency import UserNotifications

@MainActor
final class PoedatorSavedMealTimeScheduleRemindersManager {
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

extension PoedatorSavedMealTimeScheduleRemindersManager {
	func clearBadges() {
		guard let application else {
			assertionFailure("?")
			return
		}

		application.decrementIconBadgeNumber()
	}

	func removeAllDeliveredNotifications() async {
		let deliveredNotifications = await userNotificationCenterFacade.deliveredNotifications()

		userNotificationCenterFacade.removeDeliveredNotifications(withIdentifiers: deliveredNotifications.map(\.request.identifier))
	}

	func removeAllPendingNotificationRequests() async {
		let pendingNotificationRequests = await userNotificationCenterFacade.pendingNotificationRequests()

		userNotificationCenterFacade.removePendingNotificationRequests(withIdentifiers: pendingNotificationRequests.map(\.identifier))
	}

	func requestUserNotificationAuthorization() async throws -> Bool {
		try await userNotificationCenterFacade.requestAuthorization(authorizationOptions: .applicationAuthorizationOptions)
	}

	func requestToAddMealReminders(for mealTimeSchedule: PoedatorMealTimeSchedule) async throws {
		let newTriggers = createTriggers(for: mealTimeSchedule)

		let notificationRequests = await newTriggers
			.enumerated()
			.asyncMap { index, trigger in
				UNNotificationRequest(
					identifier: .notificationRequestIdentifier + " №\(index + 1)",
					content: await createNotificationContent(
						forMealTimeSerialNumber: UInt(index),
						mealTimeScheduleCount: UInt(newTriggers.count)
					),
					trigger: trigger
				)
			}

		for notificationRequest in notificationRequests {
			try await userNotificationCenterFacade.add(notificationRequest: notificationRequest)
		}
	}
}

private extension PoedatorSavedMealTimeScheduleRemindersManager {
	func createTriggers(
		for mealTimeSchedule: PoedatorMealTimeSchedule
	) -> [UNCalendarNotificationTrigger] {
		mealTimeSchedule.map { mealTime in
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
		mealTimeScheduleCount: UInt
	) -> UNNotificationContent {
		let content = UNMutableNotificationContent()

		content.title = String(localized: "Poedator notification title")
		content.body = createNotificationBody(
			forMealTimeSerialNumber: serialNumber,
			mealTimeScheduleCount: mealTimeScheduleCount
		)
		content.sound = .default

		let badgeValue = (application?.applicationIconBadgeNumber ?? 0) + 1
		// swiftlint:disable:next legacy_objc_type
		content.badge = badgeValue as NSNumber

		return content
	}

	func createNotificationBody(
		forMealTimeSerialNumber mealTimeSerialNumber: UInt,
		mealTimeScheduleCount: UInt
	) -> String {
		if mealTimeScheduleCount == 3 {
			return mealTimeNameFor3MealsADay(
				mealTimeSerialNumber: UInt8(mealTimeSerialNumber)
			)
		}

		if mealTimeScheduleCount == 5 {
			return mealTimeNameFor5MealsADay(
				mealTimeSerialNumber: UInt8(mealTimeSerialNumber)
			)
		}

		return String(localized: "Poedator notification №\(mealTimeSerialNumber + 1) body")
	}

	func mealTimeNameFor3MealsADay(
		mealTimeSerialNumber: UInt8
	) -> String {
		switch mealTimeSerialNumber {
		case 0:
			return String(localized: "Poedator breakfast notification body")

		case 1:
			return String(localized: "Poedator lunch notification body")

		case 2:
			return String(localized: "Poedator dinner notification body")

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
			return String(localized: "Poedator breakfast notification body")

		case 1:
			return String(localized: "Poedator second breakfast notification body")

		case 2:
			return String(localized: "Poedator lunch notification body")

		case 3:
			return String(localized: "Poedator afternoon snack notification body")

		case 4:
			return String(localized: "Poedator dinner notification body")

		default:
			assertionFailure("?")
			return ""
		}
	}
}

private extension UNAuthorizationOptions {
	static var applicationAuthorizationOptions: Self {
		[.badge, .sound, .alert, .carPlay]
	}
}

private extension String {
	static var notificationRequestIdentifier: Self {
		"Meal reminder notification"
	}
}
