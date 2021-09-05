//
//  DependenciesStorage.swift
//  Pomogator
//
//  Created by Anvipo on 11.09.2021.
//

import UIKit

// swiftlint:disable file_types_order
private extension UIImpactFeedbackGenerator.FeedbackStyle {
	static var didTapBarButtonItem: Self {
		light
	}

	static var didChangeScreen: Self {
		soft
	}

	static var didChangeExpandedState: Self {
		medium
	}
}

extension DependenciesStorage {
	static let shared = DependenciesStorage()
}
// swiftlint:enable file_types_order

final class DependenciesStorage {
	let calendar: Calendar
	let didChangeExpandedStateFeedbackGenerator: UIImpactFeedbackGenerator
	let didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator
	let didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	let locale: Locale
	let userDefaultsFacade: UserDefaultsFacade
	let userNotificationCenterFacade: UserNotificationCenterFacade

	let poedatorMealRemindersManager: PoedatorMealRemindersManager

	private init() {
		locale = Locale.autoupdatingCurrent

		var calendar = Calendar.autoupdatingCurrent
		calendar.locale = locale
		self.calendar = calendar

		didChangeExpandedStateFeedbackGenerator = UIImpactFeedbackGenerator(style: .didChangeExpandedState)
		didChangeScreenFeedbackGenerator = UIImpactFeedbackGenerator(style: .didChangeScreen)
		didTapBarButtonItemFeedbackGenerator = UIImpactFeedbackGenerator(style: .didTapBarButtonItem)

		userDefaultsFacade = UserDefaultsFacade(userDefaults: .standard)

		userNotificationCenterFacade = UserNotificationCenterFacade(
			userNotificationCenter: .current()
		)

		poedatorMealRemindersManager = PoedatorMealRemindersManager(
			application: .shared,
			calendar: calendar,
			userNotificationCenterFacade: userNotificationCenterFacade
		)
	}
}
