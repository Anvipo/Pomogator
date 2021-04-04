//
//  Poedator.MealTimeListView.Model.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//
// swiftlint:disable identifier_name

import Combine
import Foundation
import UIKit

extension Poedator.MealTimeList.View {
	final class Model: ObservableObject {
		@Published var mealTimeList: [Poedator.MealTime]
		@Published var shouldShowAddMealTimeRemindersButton: Bool
		@Published var showGoToSettingsForNotificationPermissionsAlert: Bool

		init(
			storageFacade: PoedatorStorageFacadeOutputProtocol,
			mealRemindersManager: PoedatorMealRemindersManagerProtocol
		) {
			self.storageFacade = storageFacade
			self.mealRemindersManager = mealRemindersManager

			mealTimeList = []
			shouldShowAddMealTimeRemindersButton = false
			showGoToSettingsForNotificationPermissionsAlert = false
		}

		private let storageFacade: PoedatorStorageFacadeOutputProtocol
		private let mealRemindersManager: PoedatorMealRemindersManagerProtocol

		private var didAddRemindersFeedbackGenerator: UINotificationFeedbackGenerator?
	}
}

extension Poedator.MealTimeList.View.Model {
	func onAppear() {
		mealRemindersManager.clearBadges()
		mealRemindersManager.removeAllDeliveredNotifications()

		mealTimeList = storageFacade
			.calculatedMealTimeList
			.enumerated()
			.map(Poedator.MealTime.init(id:time:))

		shouldShowAddMealTimeRemindersButton = mealRemindersManager.areMealTimeRemindersAdded
	}

	func didTapAddRemindersButton() {
		addMealReminders()
	}
}

private extension Poedator.MealTimeList.View.Model {
	func addMealReminders() {
		mealRemindersManager.removeAllDeliveredNotifications()
		mealRemindersManager.removeAllPendingNotificationRequests()
		mealRemindersManager.areMealTimeRemindersAdded = false

		mealRemindersManager.requestUserNotificationAuthorization { [self] result in
			prepareDidAddRemindersFeedbackGenerator()

			switch result {
			case let .success(wasGranted):
				if wasGranted {
					didGrantUserNotificationAuthorization()
				} else {
					didNotGrantUserNotificationAuthorization()
				}

			case let .failure(error):
				didFailGrantUserNotificationAuthorization(error: error)
			}
		}
	}

	func didGrantUserNotificationAuthorization() {
		let registeringMealTimeList = storageFacade.calculatedMealTimeList

		mealRemindersManager.requestToAddMealReminders(
			for: registeringMealTimeList
		) { [self] errors in
			guard errors.isEmpty else {
				didReceive(nonEmptyRequestErrors: errors, for: registeringMealTimeList)
				return
			}

			didAddMealReminders(for: registeringMealTimeList)
		}
	}

	func didAddMealReminders(for calculatedMealTimeList: [Date]) {
		notificateAboutDidAddReminders()
		clearDidAddRemindersFeedbackGenerator()

		mealRemindersManager.areMealTimeRemindersAdded = true

		shouldShowAddMealTimeRemindersButton = false
	}

	func didReceive(
		nonEmptyRequestErrors: [Error],
		for registeringMealTimeList: [Date]
	) {
		if nonEmptyRequestErrors.count == registeringMealTimeList.count {
			notificateAboutDidNotAddReminders()
		} else if nonEmptyRequestErrors.count < registeringMealTimeList.count {
			notificateWithWarningAboutDidNotAddReminders()
		}

		clearDidAddRemindersFeedbackGenerator()
	}

	func didNotGrantUserNotificationAuthorization() {
		showGoToSettingsForNotificationPermissionsAlert = true

		notificateAboutDidNotAddReminders()
		clearDidAddRemindersFeedbackGenerator()
	}

	func didFailGrantUserNotificationAuthorization(error: Error) {
		clearDidAddRemindersFeedbackGenerator()
		assertionFailure(error.localizedDescription)
	}

	func prepareDidAddRemindersFeedbackGenerator() {
		didAddRemindersFeedbackGenerator = UINotificationFeedbackGenerator()
		didAddRemindersFeedbackGenerator?.prepare()
	}

	func notificateAboutDidAddReminders() {
		didAddRemindersFeedbackGenerator?.notificationOccurred(.success)
	}

	func notificateAboutDidNotAddReminders() {
		didAddRemindersFeedbackGenerator?.notificationOccurred(.error)
	}

	func notificateWithWarningAboutDidNotAddReminders() {
		didAddRemindersFeedbackGenerator?.notificationOccurred(.warning)
	}

	func clearDidAddRemindersFeedbackGenerator() {
		didAddRemindersFeedbackGenerator = nil
	}
}
