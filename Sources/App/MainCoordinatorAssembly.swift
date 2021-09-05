//
//  MainCoordinatorAssembly.swift
//  App
//
//  Created by Anvipo on 15.01.2023.
//

import StoreKit
import UIKit

final class MainCoordinatorAssembly: AppTabBarCoordinatorAssembly {
	private let dependenciesStorage: DependenciesStorage

	init(dependenciesStorage: DependenciesStorage) {
		self.dependenciesStorage = dependenciesStorage
	}
}

@MainActor
extension MainCoordinatorAssembly {
	func coordinatorAndTransitionHandler(
		appCoordinator: AppCoordinator,
		windowScene: UIWindowScene
	) -> (MainCoordinator, UIViewController) {
		let navigationController = BaseNavigationController()

		navigationController.tabBarItem = makeTabBarItem(
			title: String(localized: "Main screen title"),
			image: .main,
			tag: .mainTabIndex
		)
		navigationController.navigationBar.largeContentTitle = navigationController.tabBarItem.title
		navigationController.navigationBar.largeContentImage = navigationController.tabBarItem.largeContentSizeImage
		navigationController.navigationBar.scalesLargeContentImage = true

		return (
			MainCoordinator(
				appCoordinator: appCoordinator,
				appStore: AppStore.self,
				assembly: self,
				didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator,
				windowScene: windowScene
			),
			navigationController
		)
	}

	func main(coordinator: MainCoordinator) -> BaseVC {
		let presenter = MainPresenter(
			assembly: MainAssembly(dependenciesStorage: dependenciesStorage),
			coordinator: coordinator,
			labelItemPointerInteractionDelegate: MainLabelItemPointerInteractionDelegate(),
			poedatorMealTimeScheduleStoreFacade: dependenciesStorage.keyValueStoreFacade,
			widgetCenter: .shared
		)

		let view = MainVC(
			presenter: presenter
		)
		presenter.set(view: view)

		return view
	}
}
