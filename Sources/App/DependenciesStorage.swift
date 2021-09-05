//
//  DependenciesStorage.swift
//  App
//
//  Created by Anvipo on 11.09.2021.
//

import UIKit

final class DependenciesStorage {
	let calendar: Calendar
	let didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator
	let didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator
	let didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	let spotlightManager: SpotlightManager
	let keyValueStoreFacade: KeyValueStoreFacade
	let userNotificationCenterFacade: UserNotificationCenterFacade
	let watchConnectivityFacade: WatchConnectivityFacade

	let poedatorSavedMealTimeScheduleRemindersManager: PoedatorSavedMealTimeScheduleRemindersManager

	private init() {
		calendar = .pomogator

		didTapFieldViewFeedbackGenerator = UIImpactFeedbackGenerator(style: .didTapFieldView)
		didChangeScreenFeedbackGenerator = UIImpactFeedbackGenerator(style: .didChangeScreen)
		didTapBarButtonItemFeedbackGenerator = UIImpactFeedbackGenerator(style: .didTapBarButtonItem)

		spotlightManager = SpotlightManager(searchableIndex: .default())

		keyValueStoreFacade = KeyValueStoreFacade(
			iCloud: NSUbiquitousKeyValueStore.default,
			local: UserDefaults.standard,
			shared: UserDefaults.sharedWithWidget
		)

		userNotificationCenterFacade = UserNotificationCenterFacade(
			userNotificationCenter: .current()
		)

		watchConnectivityFacade = WatchConnectivityFacade(wcSession: .default)

		poedatorSavedMealTimeScheduleRemindersManager = PoedatorSavedMealTimeScheduleRemindersManager(
			application: .shared,
			calendar: calendar,
			userNotificationCenterFacade: userNotificationCenterFacade
		)
	}
}

extension DependenciesStorage {
	static let shared = DependenciesStorage()
}

private extension UIImpactFeedbackGenerator.FeedbackStyle {
	static var didTapBarButtonItem: Self {
		light
	}

	static var didChangeScreen: Self {
		soft
	}

	static var didTapFieldView: Self {
		medium
	}
}
