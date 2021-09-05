//
//  MainCoordinatorAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit

final class MainCoordinatorAssembly: BaseAssembly {}

extension MainCoordinatorAssembly {
	func coordinatorAndTransitionHandler(
		appCoordinator: AppCoordinator,
		device: UIDevice,
		screen: UIScreen
	) -> (MainCoordinator, UIViewController) {
		let navigationController = UINavigationController()
		navigationController.navigationBar.tintColor = Color.brand.uiColor

		navigationController.tabBarItem = UITabBarItem(
			title: String(localized: "Main"),
			// swiftlint:disable:next force_try
			image: try! Image.main.proportionallyResizedImage(to: .init(side: 25)),
			tag: .mainTabIndex
		)

		return (
			MainCoordinator(
				appCoordinator: appCoordinator,
				assembly: self,
				calendar: dependenciesStorage.calendar,
				didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator,
				userDefaultsFacade: dependenciesStorage.userDefaultsFacade
			),
			navigationController
		)
	}

	func main(coordinator: MainCoordinator) -> UIViewController {
		let presenter = MainPresenter(
			assembly: MainAssembly(),
			calendar: dependenciesStorage.calendar,
			coordinator: coordinator,
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			userDefaultsFacade: dependenciesStorage.userDefaultsFacade
		)

		let view = MainVC(
			presenter: presenter
		)
		presenter.set(view: view)

		return view
	}
}
