//
//  UserNotificationCenterFacadeProtocol.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import UserNotifications

protocol UserNotificationCenterFacadeProtocol {
	func removeAllDeliveredNotifications()

	func removeAllPendingNotificationRequests()

	func requestAuthorization(
		authorizationOptions: UNAuthorizationOptions,
		completionHandler: @escaping (Result<Bool, Error>) -> Void
	)

	func add(
		notificationRequest: UNNotificationRequest,
		completionHandler: ((Result<Void, Error>) -> Void)?
	)
}

extension UserNotificationCenterFacadeProtocol {
	func add(
		notificationRequest: UNNotificationRequest
	) {
		add(notificationRequest: notificationRequest, completionHandler: nil)
	}
}
