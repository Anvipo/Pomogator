//
//  DependenciesStorage.swift
//  Pomogator
//
//  Created by Anvipo on 11.09.2021.
//

import UIKit

@MainActor
final class DependenciesStorage {
	let calendar: Calendar
	let didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator
	let didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator
	let didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	let locale: Locale
	let spotlightManager: SpotlightManager
	let userDefaultsFacade: UserDefaultsFacade
	let userNotificationCenterFacade: UserNotificationCenterFacade

	let poedatorSavedMealTimeScheduleRemindersManager: PoedatorSavedMealTimeScheduleRemindersManager

	private init() {
		locale = Locale.autoupdatingCurrent

		var calendar = Calendar.autoupdatingCurrent
		calendar.locale = locale
		self.calendar = calendar

		didTapFieldViewFeedbackGenerator = UIImpactFeedbackGenerator(style: .didTapFieldView)
		didChangeScreenFeedbackGenerator = UIImpactFeedbackGenerator(style: .didChangeScreen)
		didTapBarButtonItemFeedbackGenerator = UIImpactFeedbackGenerator(style: .didTapBarButtonItem)

		spotlightManager = SpotlightManager(searchableIndex: .default())

		userDefaultsFacade = UserDefaultsFacade(
			local: .standard,
			// swiftlint:disable:next force_unwrapping
			shared: .init(suiteName: "group.ru.anvipo.pomogator.shared")!
		)

		userNotificationCenterFacade = UserNotificationCenterFacade(
			userNotificationCenter: .current()
		)

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
