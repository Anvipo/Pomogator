//
//  SceneDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class SceneDelegate: UIResponder {
	private let appCoordinatorAssembly: AppCoordinatorAssembly
	private let poedatorMealRemindersManager: PoedatorMealRemindersManager
	private var appCoordinator: AppCoordinator?

	private weak var device: UIDevice?

	var window: UIWindow?

	init(
		appCoordinatorAssembly: AppCoordinatorAssembly,
		device: UIDevice,
		poedatorMealRemindersManager: PoedatorMealRemindersManager
	) {
		self.appCoordinatorAssembly = appCoordinatorAssembly
		self.device = device
		self.poedatorMealRemindersManager = poedatorMealRemindersManager
	}

	override convenience init() {
		self.init(
			appCoordinatorAssembly: AppCoordinatorAssembly(),
			device: .current,
			poedatorMealRemindersManager: DependenciesStorage.shared.poedatorMealRemindersManager
		)
	}
}

extension SceneDelegate: UISceneDelegate {
	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = scene as? UIWindowScene,
			  let device
		else {
			assertionFailure("?")
			return
		}

		let window = UIWindow(windowScene: windowScene)
		self.window = window

		appCoordinator = appCoordinatorAssembly.coordinator(
			application: .shared,
			device: device,
			window: window,
			windowScene: windowScene
		)
		appCoordinator?.startFlow()
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		poedatorMealRemindersManager.clearBadges()
		poedatorMealRemindersManager.removeAllDeliveredNotifications()
	}
}

extension SceneDelegate: UIWindowSceneDelegate {}
