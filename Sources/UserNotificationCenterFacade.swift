//
//  UserNotificationCenterFacade.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import UserNotifications

final class UserNotificationCenterFacade: NSObject {
	private let userNotificationCenter: UNUserNotificationCenter

	init(userNotificationCenter: UNUserNotificationCenter) {
		self.userNotificationCenter = userNotificationCenter
	}
}

extension UserNotificationCenterFacade: UNUserNotificationCenterDelegate {
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification
	) async -> UNNotificationPresentationOptions {
		[.badge, .banner, .list]
	}
}

extension UserNotificationCenterFacade {
	func removeAllPendingNotificationRequests() {
		userNotificationCenter.removeAllPendingNotificationRequests()
	}

	func removeAllDeliveredNotifications() {
		userNotificationCenter.removeAllDeliveredNotifications()
	}

	func requestAuthorization(authorizationOptions: UNAuthorizationOptions) async throws -> Bool {
		try await userNotificationCenter.requestAuthorization(options: authorizationOptions)
	}

	func add(notificationRequest: UNNotificationRequest) async throws {
		try await userNotificationCenter.add(notificationRequest)
	}
}
