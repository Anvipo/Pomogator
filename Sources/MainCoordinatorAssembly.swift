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
		windowScene: UIWindowScene
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
				didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator
			),
			navigationController
		)
	}

	func main(coordinator: MainCoordinator) -> BaseVC {
		let userDefaultsFacade = dependenciesStorage.userDefaultsFacade

		let presenter = MainPresenter(
			assembly: MainAssembly(),
			calendar: dependenciesStorage.calendar,
			coordinator: coordinator,
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			poedatorUserDefaultsFacade: PoedatorUserDefaultsFacade(userDefaultsFacade: userDefaultsFacade),
			vychislyatorBodyMassIndexUserDefaultsFacade: .init(userDefaultsFacade: userDefaultsFacade),
			vychislyatorDailyCalorieIntakeUserDefaultsFacade: .init(userDefaultsFacade: userDefaultsFacade)
		)

		let view = MainVC(
			presenter: presenter
		)
		presenter.set(view: view)

		return view
	}
}
