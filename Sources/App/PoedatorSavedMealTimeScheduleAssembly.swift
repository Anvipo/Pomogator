//
//  PoedatorSavedMealTimeScheduleAssembly.swift
//  App
//
//  Created by Anvipo on 18.08.2024.
//

import UIKit

final class PoedatorSavedMealTimeScheduleAssembly {
	private let dependenciesStorage: DependenciesStorage

	init(dependenciesStorage: DependenciesStorage) {
		self.dependenciesStorage = dependenciesStorage
	}
}

@MainActor
extension PoedatorSavedMealTimeScheduleAssembly {
	func makeVC(coordinator: PoedatorCoordinator) -> BaseVC {
		let presenter = PoedatorSavedMealTimeSchedulePresenter(
			bundle: .main,
			coordinator: coordinator,
			savedMealTimeScheduleRemindersManager: dependenciesStorage.poedatorSavedMealTimeScheduleRemindersManager,
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			poedatorMealTimeScheduleStoreFacade: dependenciesStorage.keyValueStoreFacade,
			viewModelFactory: PoedatorSavedMealTimeScheduleViewModelFactory(
				calculateMealTimeScheduleViewModelFactory: PoedatorCalculateMealTimeScheduleViewModelFactory(
					dependenciesStorage: dependenciesStorage
				)
			),
			watchConnectivityFacade: dependenciesStorage.watchConnectivityFacade,
			widgetCenter: .shared
		)
		coordinator.delegate = presenter

		let view = PoedatorSavedMealTimeScheduleVC(
			presenter: presenter
		)
		presenter.set(view: view)

		return view
	}
}
