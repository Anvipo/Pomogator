//
//  SceneNotification.swift
//  App
//
//  Created by Anvipo on 09.03.2023.
//

import UIKit

struct SceneNotification {
	let name: Name
	let scene: UIScene
}

extension SceneNotification {
	init(notification: Notification) throws {
		guard let name = Name(nsAnalog: notification.name) else {
			let error = MapFromNotificationError.notSceneObject
			assertionFailure(error.localizedDescription)
			throw error
		}

		guard let object = notification.object else {
			let error = MapFromNotificationError.nilObject
			assertionFailure(error.localizedDescription)
			throw error
		}

		guard let scene = object as? UIScene else {
			let error = MapFromNotificationError.notSceneObject
			assertionFailure(error.localizedDescription)
			throw error
		}

		if notification.userInfo != nil {
			assertionFailure("?")
		}

		self.init(name: name, scene: scene)
	}
}
