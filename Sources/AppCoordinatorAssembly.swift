//
//  AppCoordinatorAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class AppCoordinatorAssembly: BaseAssembly {}

extension AppCoordinatorAssembly {
	var appTabBarController: UITabBarController {
		let tabBarController = AppTabBarController(
			didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator
		)
		tabBarController.tabBar.tintColor = Color.brand.uiColor

		return tabBarController
	}

	func coordinator(
		application: UIApplication,
		device: UIDevice,
		screen: UIScreen,
		window: UIWindow
	) -> AppCoordinator {
		AppCoordinator(
			application: application,
			assembly: self,
			device: device,
			didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator,
			poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly(),
			mainCoordinatorAssembly: MainCoordinatorAssembly(),
			screen: screen,
			window: window
		)
	}
}
