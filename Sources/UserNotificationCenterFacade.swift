//
//  UserNotificationCenterFacade.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import UserNotifications

final class UserNotificationCenterFacade: NSObject {
	static let shared: UserNotificationCenterFacadeProtocol = UserNotificationCenterFacade()

	override private init() {}
}

extension UserNotificationCenterFacade: UNUserNotificationCenterDelegate {
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		completionHandler([.list, .banner])
	}
}

extension UserNotificationCenterFacade: UserNotificationCenterFacadeProtocol {
	func removeAllPendingNotificationRequests() {
		userNotificationCenter.removeAllPendingNotificationRequests()
	}

	func removeAllDeliveredNotifications() {
		userNotificationCenter.removeAllDeliveredNotifications()
	}

	func requestAuthorization(
		authorizationOptions: UNAuthorizationOptions,
		completionHandler: @escaping (Result<Bool, Error>) -> Void
	) {
		userNotificationCenter.requestAuthorization(options: authorizationOptions) { wasGranted, error in
			DispatchQueue.main.async {
				if let error = error {
					completionHandler(.failure(error))
				} else {
					completionHandler(.success(wasGranted))
				}
			}
		}
	}

	func add(
		notificationRequest: UNNotificationRequest,
		completionHandler: ((Result<Void, Error>) -> Void)?
	) {
		userNotificationCenter.add(notificationRequest) { error in
			DispatchQueue.main.async {
				if let error = error {
					completionHandler?(.failure(error))
				} else {
					completionHandler?(.success(()))
				}
			}
		}
	}
}

private extension UserNotificationCenterFacade {
	var userNotificationCenter: UNUserNotificationCenter {
		UNUserNotificationCenter.current()
	}
}
