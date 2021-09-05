//
//  DependenciesStorage.swift
//  Pomogator
//
//  Created by Anvipo on 11.09.2021.
//

import UIKit

// swiftlint:disable:next file_types_order
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

// swiftlint:disable:next file_types_order
extension DependenciesStorage {
	static let shared = DependenciesStorage()
}

@MainActor
final class DependenciesStorage {
	let calendar: Calendar
	let didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator
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

		didTapFieldViewFeedbackGenerator = UIImpactFeedbackGenerator(style: .didTapFieldView)
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
