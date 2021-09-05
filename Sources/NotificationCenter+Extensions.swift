//
//  NotificationCenter+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 21.08.2022.
//

import UIKit

typealias OnReceiveKeyboardNotification = @MainActor @Sendable (Result<KeyboardNotification, Error>) -> Void

// MARK: - Change keyboard frame extensions

extension NotificationCenter {
	func willChangeKeyboardFrameNotifications(onReceiveNotification: @escaping OnReceiveKeyboardNotification) async {
		await keyboardNotifications(named: UIResponder.keyboardWillChangeFrameNotification, onReceiveNotification: onReceiveNotification)
	}
}

// MARK: - Private

private extension NotificationCenter {
	@MainActor
	func keyboardNotifications(
		named name: Notification.Name,
		onReceiveNotification: @escaping OnReceiveKeyboardNotification
	) async {
		for await notification in notifications(named: name, object: nil) {
			let result: Result<KeyboardNotification, Error>
			do {
				let keyboardNotification = try KeyboardNotification(notification: notification)
				result = .success(keyboardNotification)
			} catch let error as KeyboardNotification.MapFromNotificationError {
				assertionFailure(error.localizedDescription)
				result = .failure(error)
			} catch {
				assertionFailure(error.localizedDescription)
				result = .failure(error)
			}

			onReceiveNotification(result)
		}
	}
}
