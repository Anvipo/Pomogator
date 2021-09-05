//
//  PoedatorCalculateMealTimeScheduleAssembly.swift
//  App
//
//  Created by Anvipo on 18.08.2024.
//

import UIKit

final class PoedatorCalculateMealTimeScheduleAssembly {
	private let dependenciesStorage: DependenciesStorage

	init(dependenciesStorage: DependenciesStorage) {
		self.dependenciesStorage = dependenciesStorage
	}
}

@MainActor
extension PoedatorCalculateMealTimeScheduleAssembly {
	func makeVC(
		coordinator: PoedatorCoordinator,
		currentNumberOfMealTimes: UInt?,
		currentFirstMealTime: Date?,
		currentLastMealTime: Date?,
		shouldAutoDeleteMealSchedule: Bool,
		window: BaseWindow
	) -> (vc: BaseVC, presenterInput: IPoedatorCalculateMealTimeSchedulePresenterInput) {
		let presenter = PoedatorCalculateMealTimeSchedulePresenter(
			calendar: dependenciesStorage.calendar,
			coordinator: coordinator,
			currentNumberOfMealTimes: currentNumberOfMealTimes,
			currentFirstMealTime: currentFirstMealTime,
			currentLastMealTime: currentLastMealTime,
			didTapFieldViewFeedbackGenerator: dependenciesStorage.didTapFieldViewFeedbackGenerator,
			didTapBarButtonItemFeedbackGenerator: dependenciesStorage.didTapBarButtonItemFeedbackGenerator,
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			poedatorMealTimeScheduleStoreFacade: dependenciesStorage.keyValueStoreFacade,
			selectionFeedbackGenerator: UISelectionFeedbackGenerator(),
			shouldAutoDeleteMealSchedule: shouldAutoDeleteMealSchedule,
			viewModelFactory: PoedatorCalculateMealTimeScheduleViewModelFactory(
				dependenciesStorage: dependenciesStorage
			),
			watchConnectivityFacade: dependenciesStorage.watchConnectivityFacade,
			widgetCenter: .shared
		)
		let view = PoedatorCalculateMealTimeScheduleVC(
			presenter: presenter,
			window: window
		)
		presenter.set(view: view)

		return (view, presenter)
	}
}
