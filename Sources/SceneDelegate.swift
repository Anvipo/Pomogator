//
//  SceneDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class SceneDelegate: UIResponder {
	var window: UIWindow?
}

extension SceneDelegate: UISceneDelegate {
	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = scene as? UIWindowScene else {
			assertionFailure("?")
			return
		}

		window = UIWindow(windowScene: windowScene)
		window?.rootViewController = ViewController()
		window?.makeKeyAndVisible()
	}
}

extension SceneDelegate: UIWindowSceneDelegate {}
