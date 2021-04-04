//
//  Poedator.MealRemindersManager.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import UIKit

extension Poedator {
	final class MealRemindersManager {
		init(
			storageFacade: PoedatorStorageFacadeInputProtocol & PoedatorStorageFacadeOutputProtocol
		) {
			userNotificationCenterFacade = UserNotificationCenterFacade.shared
			self.storageFacade = storageFacade
		}

		private let storageFacade: PoedatorStorageFacadeInputProtocol & PoedatorStorageFacadeOutputProtocol
		private let userNotificationCenterFacade: UserNotificationCenterFacadeProtocol

		private static let authorizationOptions: UNAuthorizationOptions = [.badge, .sound, .alert, .carPlay, .announcement]

		private static let identifier = "Meal reminder notification"
	}
}

extension Poedator.MealRemindersManager: PoedatorMealRemindersManagerProtocol {
	var areMealTimeRemindersAdded: Bool {
		get {
			storageFacade.areMealTimeRemindersAdded
		}
		set {
			storageFacade.save(areMealTimeRemindersAdded: newValue)
		}
	}

	func clearBadges() {
		UIApplication.shared.applicationIconBadgeNumber = 0
	}

	func removeAllDeliveredNotifications() {
		userNotificationCenterFacade.removeAllDeliveredNotifications()
	}

	func removeAllPendingNotificationRequests() {
		userNotificationCenterFacade.removeAllPendingNotificationRequests()
	}

	func requestUserNotificationAuthorization(
		completionHandler: @escaping (Result<Bool, Error>) -> Void
	) {
		userNotificationCenterFacade.requestAuthorization(
			authorizationOptions: Self.authorizationOptions,
			completionHandler: completionHandler
		)
	}

	func requestToAddMealReminders(
		for mealTimeList: [Date],
		completionHandler: @escaping ([Error]) -> Void
	) {
		let newTriggers = createTriggers(for: mealTimeList)

		let notificationRequests = newTriggers
			.enumerated()
			.map { index, trigger in
				UNNotificationRequest(
					identifier: Self.identifier + " №\(index + 1)",
					content: createNotificationContent(
						forMealTimeSerialNumber: UInt(index),
						mealTimeListCount: UInt(newTriggers.count)
					),
					trigger: trigger
				)
			}

		var errors: [Error] = []

		for (index, notificationRequest) in notificationRequests.enumerated() {
			userNotificationCenterFacade.add(
				notificationRequest: notificationRequest
			) { result in
				guard case let .failure(error) = result else {
					if index == notificationRequests.count - 1 {
						completionHandler(errors)
					}
					return
				}

				errors.append(error)

				if index == notificationRequests.count - 1 {
					completionHandler(errors)
				}
			}
		}
	}
}

private extension Poedator.MealRemindersManager {
	func createTriggers(
		for mealTimeList: [Date]
	) -> [UNCalendarNotificationTrigger] {
		mealTimeList.map {
			let triggerDate = Calendar.my.dateComponents(
				[.year, .month, .day, .hour, .minute, .second],
				from: $0
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

		content.title = "Уведомление от Поедатора"
		content.body = createNotificationBody(
			forMealTimeSerialNumber: serialNumber,
			mealTimeListCount: mealTimeListCount
		)
		content.sound = UNNotificationSound.default
		content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber

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

		return "Время \(mealTimeSerialNumber + 1) приёма пищи"
	}

	func mealTimeNameFor3MealsADay(
		mealTimeSerialNumber: UInt8
	) -> String {
		switch mealTimeSerialNumber {
		case 0:
			return "Пора завтракать"
		case 1:
			return "Пора обедать"
		case 2:
			return "Пора ужинать"
		default:
			assertionFailure("Число должны быть в 0...2")
			return ""
		}
	}

	func mealTimeNameFor5MealsADay(
		mealTimeSerialNumber: UInt8
	) -> String {
		switch mealTimeSerialNumber {
		case 0:
			return "Пора завтракать"
		case 1:
			return "Время принимать второй завтрак"
		case 2:
			return "Пора обедать"
		case 3:
			return "Время полдника"
		case 4:
			return "Пора ужинать"
		default:
			assertionFailure("Число должны быть в 0...4")
			return ""
		}
	}
}
