//
//  PoedatorMealRemindersManagerProtocol.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

protocol PoedatorMealRemindersManagerProtocol: AnyObject {
	func requestUserNotificationAuthorization(
		completionHandler: @escaping (Result<Bool, Error>) -> Void
	)

	func requestToAddMealReminders(
		for mealTimeList: [Date],
		completionHandler: @escaping ([Error]) -> Void
	)

	func removeAllDeliveredNotifications()

	func removeAllPendingNotificationRequests()

	func clearBadges()

	var areMealTimeRemindersAdded: Bool { get set }
}
