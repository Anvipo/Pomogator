//
//  BasePresenter.swift
//  App
//
//  Created by Anvipo on 07.01.2024.
//

import Foundation

@MainActor
class BasePresenter {
	var tasks: [AnyTask]

	init() {
		tasks = []
	}
}

extension BasePresenter {
	func observeVoiceOverStatusDidChange(
		onReceiveNotification: @escaping OnReceiveAccessibilityNotification
	) {
		let task = Task {
			await NotificationCenter.default.didChangeVoiceOverStatusNotifications(
				onReceiveNotification: onReceiveNotification
			)
		}

		tasks.append(task)
	}

	func observeDidChangeExternallyNotification(
		onReceiveNotification: @escaping OnReceiveUbiquitousKeyValueStoreNotification
	) {
		let task = Task {
			await NotificationCenter.default.didChangeExternallyNotification(
				onReceiveNotification: onReceiveNotification
			)
		}

		tasks.append(task)
	}
}
