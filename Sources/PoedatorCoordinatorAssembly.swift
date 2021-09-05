//
//  PoedatorCoordinatorAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class PoedatorCoordinatorAssembly: BaseAssembly {}

extension PoedatorCoordinatorAssembly {
	func coordinatorAndTransitionHandler(
		application: UIApplication,
		device: UIDevice,
		screen: UIScreen
	) -> (PoedatorCoordinator, UIViewController) {
		let transitionHandler: UIViewController
		if device.isPad {
			let splitViewController = UISplitViewController()
			// чтобы в вертикальной ориентации тоже было разбиение на master и details
			splitViewController.preferredDisplayMode = .oneBesideSecondary
			splitViewController.preferredPrimaryColumnWidthFraction = 0.5
			splitViewController.maximumPrimaryColumnWidth = screen.bounds.width / 2

			transitionHandler = splitViewController
		} else {
			let navigationController = UINavigationController()
			navigationController.navigationBar.tintColor = Color.brand.uiColor

			transitionHandler = navigationController
		}
		transitionHandler.tabBarItem = UITabBarItem(
			title: String(localized: "Poedator"),
			// swiftlint:disable:next force_try
			image: try! Image.poedator.proportionallyResizedImage(to: .init(side: 25)),
			tag: .poedatorTabIndex
		)

		return (
			PoedatorCoordinator(
				application: application,
				assembly: self,
				calendar: dependenciesStorage.calendar,
				didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator,
				userDefaultsFacade: dependenciesStorage.userDefaultsFacade
			),
			transitionHandler
		)
	}

	func yourMealTimeList(coordinator: PoedatorCoordinator) -> UIViewController {
		let presenter = PoedatorYourMealTimeListPresenter(
			assembly: PoedatorYourMealTimeListAssembly(),
			calendar: dependenciesStorage.calendar,
			coordinator: coordinator,
			mealRemindersManager: dependenciesStorage.poedatorMealRemindersManager,
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			userDefaultsFacade: dependenciesStorage.userDefaultsFacade
		)

		let view = PoedatorYourMealTimeListVC(
			presenter: presenter
		)
		presenter.set(view: view)

		return view
	}

	func calculateMealTimeList(
		coordinator: PoedatorCoordinator,
		inputedNumberOfMealTimes: UInt?,
		inputedFirstMealTime: Date?,
		inputedLastMealTime: Date?
	) -> UIViewController {
		let presenter = PoedatorCalculateMealTimeListPresenter(
			assembly: PoedatorCalculateMealTimeListAssembly(),
			calendar: dependenciesStorage.calendar,
			coordinator: coordinator,
			didTapBarButtonItemFeedbackGenerator: dependenciesStorage.didTapBarButtonItemFeedbackGenerator,
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			inputedNumberOfMealTimes: inputedNumberOfMealTimes,
			inputedFirstMealTime: inputedFirstMealTime,
			inputedLastMealTime: inputedLastMealTime,
			userDefaultsFacade: dependenciesStorage.userDefaultsFacade
		)
		let view = PoedatorCalculateMealTimeListVC(
			presenter: presenter
		)
		presenter.set(view: view)

		return view
	}
}
