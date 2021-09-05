//
//  PoedatorSavedMealTimeScheduleRemindersManager.swift
//  App
//
//  Created by Anvipo on 12.09.2021.
//

import UIKit
@preconcurrency import UserNotifications

extension String {
	static var mealReminderNotificationRequestPrefixIdentifier: Self {
		"Meal reminder notification"
	}
}

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
	func clearBadges() async throws {
		try await userNotificationCenterFacade.set(badgeCount: 0)
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
}

@MainActor
extension PoedatorSavedMealTimeScheduleRemindersManager {
	func requestToAddMealReminders(for mealTimeSchedule: PoedatorMealTimeSchedule) async throws {
		let newTriggers = createTriggers(for: mealTimeSchedule)

		let notificationRequests = newTriggers
			.enumerated()
			.map { index, trigger in
				UNNotificationRequest(
					identifier: .mealReminderNotificationRequestPrefixIdentifier + " №\(index + 1)",
					content: createNotificationContent(
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

@MainActor
private extension PoedatorSavedMealTimeScheduleRemindersManager {
	var applicationIconBadgeNumber: Int {
		application?.applicationIconBadgeNumber ?? 0
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

		let badgeValue = applicationIconBadgeNumber + 1
		content.badge = badgeValue.nsNumber

		return content
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

	func createNotificationBody(
		forMealTimeSerialNumber mealTimeSerialNumber: UInt,
		mealTimeScheduleCount: UInt
	) -> String {
		if mealTimeScheduleCount == 3 {
			return mealTimeNameFor3MealsADay(
				mealTimeSerialNumber: UInt8(mealTimeSerialNumber)
			)
		}

		if mealTimeScheduleCount == 4 {
			return mealTimeNameFor4MealsADay(
				mealTimeSerialNumber: UInt8(mealTimeSerialNumber)
			)
		}

		if mealTimeScheduleCount == 5 {
			return mealTimeNameFor5MealsADay(
				mealTimeSerialNumber: UInt8(mealTimeSerialNumber)
			)
		}

		let mealTimeSerialNumberString = (mealTimeSerialNumber + 1).formatted(
			PoedatorCalculateMealTimeScheduleViewModelFactory.currentNumberOfMealTimesFormatStyle
		)

		return String(localized: "Poedator notification №\(mealTimeSerialNumberString) body")
	}

	func mealTimeNameFor3MealsADay(
		mealTimeSerialNumber: UInt8
	) -> String {
		if mealTimeSerialNumber == 0 {
			return String(localized: "Poedator breakfast notification body")
		}

		if mealTimeSerialNumber == 1 {
			return String(localized: "Poedator lunch notification body")
		}

		if mealTimeSerialNumber == 2 {
			return String(localized: "Poedator dinner notification body")
		}

		assertionFailure("?")
		return ""
	}

	func mealTimeNameFor4MealsADay(
		mealTimeSerialNumber: UInt8
	) -> String {
		if mealTimeSerialNumber == 0 {
			return String(localized: "Poedator breakfast notification body")
		}

		if mealTimeSerialNumber == 1 {
			return String(localized: "Poedator lunch notification body")
		}

		if mealTimeSerialNumber == 2 {
			return String(localized: "Poedator afternoon snack notification body")
		}

		if mealTimeSerialNumber == 3 {
			return String(localized: "Poedator dinner notification body")
		}

		assertionFailure("?")
		return ""
	}

	func mealTimeNameFor5MealsADay(
		mealTimeSerialNumber: UInt8
	) -> String {
		if mealTimeSerialNumber == 0 {
			return String(localized: "Poedator breakfast notification body")
		}

		if mealTimeSerialNumber == 1 {
			return String(localized: "Poedator second breakfast notification body")
		}

		if mealTimeSerialNumber == 2 {
			return String(localized: "Poedator lunch notification body")
		}

		if mealTimeSerialNumber == 3 {
			return String(localized: "Poedator afternoon snack notification body")
		}

		if mealTimeSerialNumber == 4 {
			return String(localized: "Poedator dinner notification body")
		}

		assertionFailure("?")
		return ""
	}
}

private extension UNAuthorizationOptions {
	static var applicationAuthorizationOptions: Self {
		[.badge, .sound, .alert, .carPlay]
	}
}
