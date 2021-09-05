//
//  AppCoordinatorAssembly.swift
//  App
//
//  Created by Anvipo on 20.09.2021.
//

import StoreKit
import UIKit

final class AppCoordinatorAssembly {
	private let dependenciesStorage: DependenciesStorage

	init(dependenciesStorage: DependenciesStorage) {
		self.dependenciesStorage = dependenciesStorage
	}
}

@MainActor
extension AppCoordinatorAssembly {
	func appTabBarController(coordinator: AppCoordinator) -> IRestorable & BaseTabBarController {
		AppTabBarController(coordinator: coordinator)
	}

	func coordinator(
		application: UIApplication,
		device: UIDevice,
		window: BaseWindow,
		windowScene: UIWindowScene
	) -> AppCoordinator {
		let coordinator = AppCoordinator(
			application: application,
			appStore: AppStore.self,
			assembly: self,
			device: device,
			didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator,
			mainCoordinatorAssembly: MainCoordinatorAssembly(dependenciesStorage: dependenciesStorage),
			poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly(dependenciesStorage: dependenciesStorage),
			spotlightManager: dependenciesStorage.spotlightManager,
			window: window,
			windowScene: windowScene
		)

		dependenciesStorage.userNotificationCenterFacade.appCoordinator = coordinator

		return coordinator
	}
}
