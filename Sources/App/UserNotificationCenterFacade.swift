//
//  UserNotificationCenterFacade.swift
//  App
//
//  Created by Anvipo on 12.09.2021.
//

import UserNotifications

final class UserNotificationCenterFacade: NSObject {
	private let userNotificationCenter: UNUserNotificationCenter

	weak var appCoordinator: AppCoordinator?

	init(userNotificationCenter: UNUserNotificationCenter) {
		self.userNotificationCenter = userNotificationCenter
	}
}

@MainActor
extension UserNotificationCenterFacade: UNUserNotificationCenterDelegate {
	// swiftlint:disable:next unused_parameter
	func userNotificationCenter(_: UNUserNotificationCenter, willPresent: UNNotification) async -> UNNotificationPresentationOptions {
		[.badge, .banner, .list]
	}

	func userNotificationCenter(
		_: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse
	) async {
		if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
			if response.notification.request.identifier.hasPrefix(.mealReminderNotificationRequestPrefixIdentifier) {
				guard let appCoordinator else {
					assertionFailure("?")
					return
				}

				appCoordinator.goToPoedator()
			}
		}
	}
}

extension UserNotificationCenterFacade {
	func set(badgeCount: Int) async throws {
		try await userNotificationCenter.setBadgeCount(badgeCount)
	}

	func pendingNotificationRequests() async -> [UNNotificationRequest] {
		await userNotificationCenter.pendingNotificationRequests()
	}

	func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
		userNotificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
	}

	func deliveredNotifications() async -> [UNNotification] {
		await userNotificationCenter.deliveredNotifications()
	}

	func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
		userNotificationCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
	}

	func requestAuthorization(authorizationOptions: UNAuthorizationOptions) async throws -> Bool {
		try await userNotificationCenter.requestAuthorization(options: authorizationOptions)
	}

	func add(notificationRequest: UNNotificationRequest) async throws {
		try await userNotificationCenter.add(notificationRequest)
	}
}
