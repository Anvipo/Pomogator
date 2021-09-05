//
//  NotificationCenter+Extensions.swift
//  App
//
//  Created by Anvipo on 21.08.2022.
//

import UIKit

// MARK: - Change keyboard frame extensions

typealias OnReceiveKeyboardNotification = @MainActor @Sendable (Result<KeyboardNotification, Error>) -> Void

extension NotificationCenter {
	func willChangeKeyboardFrameNotifications(
		onReceiveNotification: @escaping OnReceiveKeyboardNotification
	) async {
		await keyboardNotifications(
			named: UIResponder.keyboardWillChangeFrameNotification,
			onReceiveNotification: onReceiveNotification
		)
	}
}

// MARK: - UIScene extensions

typealias OnReceiveSceneNotification = @MainActor @Sendable (Result<SceneNotification, Error>) -> Void

extension NotificationCenter {
	func willEnterForegroundNotifications(
		onReceiveNotification: @escaping OnReceiveSceneNotification
	) async {
		await sceneNotifications(
			named: UIScene.willEnterForegroundNotification,
			onReceiveNotification: onReceiveNotification
		)
	}
}

// MARK: - UIAccessibility extensions

typealias OnReceiveAccessibilityNotification = @MainActor @Sendable () -> Void

extension NotificationCenter {
	func didChangeVoiceOverStatusNotifications(
		onReceiveNotification: @escaping OnReceiveAccessibilityNotification
	) async {
		await accessibilityNotifications(
			named: UIAccessibility.voiceOverStatusDidChangeNotification,
			onReceiveNotification: onReceiveNotification
		)
	}

	func didChangeReduceTransparencyStatusNotifications(
		onReceiveNotification: @escaping OnReceiveAccessibilityNotification
	) async {
		await accessibilityNotifications(
			named: UIAccessibility.reduceTransparencyStatusDidChangeNotification,
			onReceiveNotification: onReceiveNotification
		)
	}
}

// MARK: - Did change externally extensions

typealias OnReceiveUbiquitousKeyValueStoreNotification = @MainActor @Sendable (
	Result<UbiquitousKeyValueStoreDidChangeExternallyNotification, Error>
) -> Void

extension NotificationCenter {
	func didChangeExternallyNotification(
		onReceiveNotification: @escaping OnReceiveUbiquitousKeyValueStoreNotification
	) async {
		for await notification in notifications(
			named: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
			object: NSUbiquitousKeyValueStore.default
		) {
			let result: Result<UbiquitousKeyValueStoreDidChangeExternallyNotification, Error>
			do {
				let keyboardNotification = try UbiquitousKeyValueStoreDidChangeExternallyNotification(notification: notification)
				result = .success(keyboardNotification)
			} catch let error as UbiquitousKeyValueStoreDidChangeExternallyNotification.MapFromNotificationError {
				assertionFailure(error.localizedDescription)
				result = .failure(error)
			} catch {
				assertionFailure(error.localizedDescription)
				result = .failure(error)
			}
			await onReceiveNotification(result)
		}
	}
}

// MARK: - Private

private extension NotificationCenter {
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

			await onReceiveNotification(result)
		}
	}

	func sceneNotifications(
		named name: Notification.Name,
		onReceiveNotification: @escaping OnReceiveSceneNotification
	) async {
		for await notification in notifications(named: name, object: nil) {
			let result: Result<SceneNotification, Error>
			do {
				let keyboardNotification = try SceneNotification(notification: notification)
				result = .success(keyboardNotification)
			} catch let error as SceneNotification.MapFromNotificationError {
				assertionFailure(error.localizedDescription)
				result = .failure(error)
			} catch {
				assertionFailure(error.localizedDescription)
				result = .failure(error)
			}

			await onReceiveNotification(result)
		}
	}

	func accessibilityNotifications(
		named name: Notification.Name,
		onReceiveNotification: @escaping OnReceiveAccessibilityNotification
	) async {
		for await _ in notifications(named: name, object: nil) {
			await onReceiveNotification()
		}
	}
}
