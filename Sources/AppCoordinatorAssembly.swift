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

		let stackedAppearance = UITabBarItemAppearance(style: .stacked)
		stackedAppearance.normal.iconColor = .black
		stackedAppearance.normal.titleTextAttributes = [
			.foregroundColor: stackedAppearance.normal.iconColor
		]
		stackedAppearance.selected.iconColor = .white
		stackedAppearance.selected.titleTextAttributes = [
			.foregroundColor: stackedAppearance.selected.iconColor
		]

		let appearance = UITabBarAppearance()
		appearance.stackedLayoutAppearance = stackedAppearance
		appearance.inlineLayoutAppearance = stackedAppearance
		appearance.compactInlineLayoutAppearance = stackedAppearance

		appearance.configureWithTransparentBackground()
//		appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

		tabBarController.tabBar.standardAppearance = appearance
		tabBarController.tabBar.scrollEdgeAppearance = appearance

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
