//
//  PoedatorCoordinatorAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class PoedatorCoordinatorAssembly: BaseAssembly {}

extension PoedatorCoordinatorAssembly: IAppTabBarCoordinatorAssembly {
	var spotlightSearchableItems: [SpotlightSearchableItem] {
		let title = String(localized: "Poedator")
		let keywords = [
			title,
			String(localized: "Fitness spotlight keyword"),
			String(localized: "Reminder spotlight keyword"),
			String(localized: "Food spotlight keyword"),
			String(localized: "To eat spotlight keyword 1"),
			String(localized: "To eat spotlight keyword 2"),
			String(localized: "Meal spotlight keyword"),
			String(localized: "Breakfast spotlight keyword"),
			String(localized: "Lunch spotlight keyword"),
			String(localized: "Snack spotlight keyword"),
			String(localized: "Dinner spotlight keyword")
		]

		return [
			defaultSpotlightSearchableItem(
				contentDescription: String(localized: "Poedator spotlight content description"),
				keywords: keywords,
				thumbnailData: Image.poedator.uiImage.pngData(),
				title: title,
				uniqueIdentifier: spotlightSearchableUniqueIdentifier
			)
		]
	}
}

extension PoedatorCoordinatorAssembly {
	var spotlightSearchableUniqueIdentifier: String {
		"poedator"
	}

	func coordinatorAndTransitionHandler(
		application: UIApplication,
		device: UIDevice,
		windowScene: UIWindowScene
	) -> (PoedatorCoordinator, UIViewController) {
		let transitionHandler: UIViewController
		if device.userInterfaceIdiom == .pad {
			let splitViewController = UISplitViewController()
			// чтобы в вертикальной ориентации тоже было разбиение на master и details
			splitViewController.preferredDisplayMode = .oneBesideSecondary
			splitViewController.preferredPrimaryColumnWidthFraction = 0.5
			splitViewController.maximumPrimaryColumnWidth = windowScene.screen.bounds.width / 2

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
				didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator,
				userDefaultsFacade: PoedatorUserDefaultsFacade(userDefaultsFacade: dependenciesStorage.userDefaultsFacade)
			),
			transitionHandler
		)
	}

	func savedMealTimeSchedule(coordinator: PoedatorCoordinator) -> BaseVC {
		let presenter = PoedatorSavedMealTimeSchedulePresenter(
			assembly: PoedatorSavedMealTimeScheduleAssembly(),
			calendar: dependenciesStorage.calendar,
			coordinator: coordinator,
			savedMealTimeScheduleRemindersManager: dependenciesStorage.poedatorSavedMealTimeScheduleRemindersManager,
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			userDefaultsFacade: PoedatorUserDefaultsFacade(userDefaultsFacade: dependenciesStorage.userDefaultsFacade)
		)
		coordinator.delegate = presenter

		let view = PoedatorSavedMealTimeScheduleVC(
			presenter: presenter
		)
		presenter.set(view: view)

		return view
	}

	func calculateMealTimeSchedule(
		coordinator: PoedatorCoordinator,
		currentNumberOfMealTimes: UInt?,
		currentFirstMealTime: Date?,
		currentLastMealTime: Date?
	) -> BaseVC {
		let presenter = PoedatorCalculateMealTimeSchedulePresenter(
			assembly: PoedatorCalculateMealTimeScheduleAssembly(),
			calendar: dependenciesStorage.calendar,
			coordinator: coordinator,
			didTapFieldViewFeedbackGenerator: dependenciesStorage.didTapFieldViewFeedbackGenerator,
			didTapBarButtonItemFeedbackGenerator: dependenciesStorage.didTapBarButtonItemFeedbackGenerator,
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			currentNumberOfMealTimes: currentNumberOfMealTimes,
			currentFirstMealTime: currentFirstMealTime,
			currentLastMealTime: currentLastMealTime,
			userDefaultsFacade: PoedatorUserDefaultsFacade(userDefaultsFacade: dependenciesStorage.userDefaultsFacade)
		)
		let view = PoedatorCalculateMealTimeScheduleVC(
			presenter: presenter
		)
		presenter.set(view: view)

		return view
	}
}
