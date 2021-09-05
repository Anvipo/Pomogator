//
//  SceneNotification.Name.swift
//  App
//
//  Created by Anvipo on 09.03.2023.
//

import UIKit

extension SceneNotification {
	enum Name {
		case willConnect
		case didDisconnect

		case didActivate
		case willDeactivate

		case willEnterForeground
		case didEnterBackground
	}
}

extension SceneNotification.Name {
	init?(nsAnalog: Notification.Name) {
		if nsAnalog == UIScene.willConnectNotification {
			self = .willConnect
		} else if nsAnalog == UIScene.didDisconnectNotification {
			self = .didDisconnect
		} else if nsAnalog == UIScene.didActivateNotification {
			self = .didActivate
		} else if nsAnalog == UIScene.willDeactivateNotification {
			self = .willDeactivate
		} else if nsAnalog == UIScene.willEnterForegroundNotification {
			self = .willEnterForeground
		} else if nsAnalog == UIScene.didEnterBackgroundNotification {
			self = .didEnterBackground
		} else {
			return nil
		}
	}
}
