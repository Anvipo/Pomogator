//
//  SceneDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class SceneDelegate: UIResponder {
	private let appAssembly: AppCoordinatorAssembly
	private let device: UIDevice
	private let poedatorMealRemindersManager: PoedatorMealRemindersManager
	private var appCoordinator: AppCoordinator?

	var window: UIWindow?

	init(
		appAssembly: AppCoordinatorAssembly,
		device: UIDevice,
		poedatorMealRemindersManager: PoedatorMealRemindersManager
	) {
		self.appAssembly = appAssembly
		self.device = device
		self.poedatorMealRemindersManager = poedatorMealRemindersManager
	}

	override convenience init() {
		self.init(
			appAssembly: AppCoordinatorAssembly(),
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
		guard let windowScene = scene as? UIWindowScene else {
			assertionFailure("?")
			return
		}

		let window = UIWindow(windowScene: windowScene)
		self.window = window

		appCoordinator = appAssembly.coordinator(
			application: .shared,
			device: device,
			screen: windowScene.screen,
			window: window
		)
		appCoordinator?.startFlow()
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		poedatorMealRemindersManager.clearBadges()
		poedatorMealRemindersManager.removeAllDeliveredNotifications()
	}
}

extension SceneDelegate: UIWindowSceneDelegate {}
