//
//  NotificationCenter+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 21.08.2022.
//

import UIKit

// MARK: - Show extensions

extension NotificationCenter {
	func willShowKeyboardNotifications(onReceiveNotification: (Result<KeyboardNotification, Error>) -> Void) async {
		await keyboardNotifications(named: UIResponder.keyboardWillShowNotification, onReceiveNotification: onReceiveNotification)
	}

	func didShowKeyboardNotifications(onReceiveNotification: (Result<KeyboardNotification, Error>) -> Void) async {
		await keyboardNotifications(named: UIResponder.keyboardDidShowNotification, onReceiveNotification: onReceiveNotification)
	}
}

// MARK: - Hide extensions

extension NotificationCenter {
	func willHideKeyboardNotifications(onReceiveNotification: (Result<KeyboardNotification, Error>) -> Void) async {
		await keyboardNotifications(named: UIResponder.keyboardWillHideNotification, onReceiveNotification: onReceiveNotification)
	}

	func didHideKeyboardNotifications(onReceiveNotification: (Result<KeyboardNotification, Error>) -> Void) async {
		await keyboardNotifications(named: UIResponder.keyboardDidHideNotification, onReceiveNotification: onReceiveNotification)
	}
}

// MARK: - Change keyboard frame extensions

extension NotificationCenter {
	func willChangeKeyboardFrameNotifications(onReceiveNotification: (Result<KeyboardNotification, Error>) -> Void) async {
		await keyboardNotifications(named: UIResponder.keyboardWillChangeFrameNotification, onReceiveNotification: onReceiveNotification)
	}

	func didChangeKeyboardFrameNotifications(onReceiveNotification: (Result<KeyboardNotification, Error>) -> Void) async {
		await keyboardNotifications(named: UIResponder.keyboardDidChangeFrameNotification, onReceiveNotification: onReceiveNotification)
	}
}

// MARK: - Private

extension NotificationCenter {
	private func keyboardNotifications(
		named name: Notification.Name,
		object: AnyObject? = nil,
		onReceiveNotification: (Result<KeyboardNotification, Error>) -> Void
	) async {
		for await notification in notifications(named: name, object: object) {
			await MainActor.run {
				do {
					let keyboardNotification = try KeyboardNotification(notification: notification)
					onReceiveNotification(.success(keyboardNotification))
				} catch let error as KeyboardNotification.MapFromNotificationError {
					assertionFailure(error.localizedDescription)
					onReceiveNotification(.failure(error))
				} catch {
					assertionFailure(error.localizedDescription)
					onReceiveNotification(.failure(error))
				}
			}
		}
	}
}
