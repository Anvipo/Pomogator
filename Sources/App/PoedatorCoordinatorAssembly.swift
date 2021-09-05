//
//  PoedatorCoordinatorAssembly.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import StoreKit
import UIKit

final class PoedatorCoordinatorAssembly: AppTabBarCoordinatorAssembly {
	private let dependenciesStorage: DependenciesStorage

	init(dependenciesStorage: DependenciesStorage) {
		self.dependenciesStorage = dependenciesStorage
	}
}

extension PoedatorCoordinatorAssembly {
	var spotlightSearchableUniqueIdentifier: String {
		"poedator"
	}
}

@MainActor
extension PoedatorCoordinatorAssembly {
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

	func coordinatorAndTransitionHandler(
		application: UIApplication,
		device: UIDevice,
		window: BaseWindow,
		windowScene: UIWindowScene
	) -> (PoedatorCoordinator, UIViewController) {
		let transitionHandler: UIViewController
		if device.userInterfaceIdiom == .pad {
			let splitViewController = PoedatorSplitViewController()
			transitionHandler = splitViewController
		} else {
			let navigationController = BaseNavigationController()
			navigationController.navigationBar.largeContentTitle = navigationController.tabBarItem.title
			navigationController.navigationBar.largeContentImage = navigationController.tabBarItem.largeContentSizeImage
			navigationController.navigationBar.scalesLargeContentImage = true

			transitionHandler = navigationController
		}
		transitionHandler.tabBarItem = makeTabBarItem(
			title: String(localized: "Poedator"),
			image: .poedator,
			tag: .poedatorTabIndex
		)

		return (
			PoedatorCoordinator(
				application: application,
				appStore: AppStore.self,
				assembly: self,
				calculateMealTimeScheduleAssembly: PoedatorCalculateMealTimeScheduleAssembly(dependenciesStorage: dependenciesStorage),
				calendar: .pomogator,
				didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator,
				poedatorMealTimeScheduleStoreFacade: dependenciesStorage.keyValueStoreFacade,
				savedMealTimeScheduleAssembly: PoedatorSavedMealTimeScheduleAssembly(dependenciesStorage: dependenciesStorage),
				window: window,
				windowScene: windowScene
			),
			transitionHandler
		)
	}
}
