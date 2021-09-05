//
//  AppCoordinatorAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class AppCoordinatorAssembly: BaseAssembly {}

extension AppCoordinatorAssembly {
	func appTabBarController(output: IAppTabBarControllerOutput) -> IRestorable & BaseTabBarController {
		let tabBarController = AppTabBarController(
			didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator,
			output: output
		)
		tabBarController.tabBar.tintColor = Color.brand.uiColor

		return tabBarController
	}

	func coordinator(
		application: UIApplication,
		device: UIDevice,
		window: UIWindow,
		windowScene: UIWindowScene
	) -> AppCoordinator {
		AppCoordinator(
			application: application,
			assembly: self,
			device: device,
			didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator,
			mainCoordinatorAssembly: MainCoordinatorAssembly(),
			poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly(),
			spotlightManager: dependenciesStorage.spotlightManager,
			window: window,
			windowScene: windowScene
		)
	}
}
