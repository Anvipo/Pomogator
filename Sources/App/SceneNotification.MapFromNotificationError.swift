//
//  SceneNotification.MapFromNotificationError.swift
//  App
//
//  Created by Anvipo on 09.03.2023.
//

import Foundation

extension SceneNotification {
	enum MapFromNotificationError {
		case notSceneNotification
		case nilObject
		case notSceneObject
	}
}

extension SceneNotification.MapFromNotificationError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .notSceneNotification: "Received notification is not scene-related"
		case .nilObject: "Notification's object is nil"
		case .notSceneObject: "Notification's object is not scene"
		}
	}
}
