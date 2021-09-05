//
//  PoedatorSavedMealTimeSchedulePresenter.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class PoedatorSavedMealTimeSchedulePresenter: BasePresenter {
	private let assembly: PoedatorSavedMealTimeScheduleAssembly
	private let calendar: Calendar
	private let coordinator: PoedatorCoordinator
	private let savedMealTimeScheduleRemindersManager: PoedatorSavedMealTimeScheduleRemindersManager
	private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
	private let userDefaultsFacade: PoedatorUserDefaultsFacade

	private var calculatedMealTimeSchedule: PoedatorMealTimeSchedule
	private var calculatedMealTimeScheduleSection: PoedatorSavedMealTimeScheduleSection?
	private weak var view: PoedatorSavedMealTimeScheduleVC?

	init(
		assembly: PoedatorSavedMealTimeScheduleAssembly,
		calendar: Calendar,
		coordinator: PoedatorCoordinator,
		savedMealTimeScheduleRemindersManager: PoedatorSavedMealTimeScheduleRemindersManager,
		notificationFeedbackGenerator: UINotificationFeedbackGenerator,
		userDefaultsFacade: PoedatorUserDefaultsFacade
	) {
		self.assembly = assembly
		self.calendar = calendar
		self.coordinator = coordinator
		self.savedMealTimeScheduleRemindersManager = savedMealTimeScheduleRemindersManager
		self.notificationFeedbackGenerator = notificationFeedbackGenerator
		self.userDefaultsFacade = userDefaultsFacade

		calculatedMealTimeSchedule = []

		super.init(baseCoordinator: coordinator)
	}

	override func baseViewDidAppear() {
		super.baseViewDidAppear()
		notificationFeedbackGenerator.prepare()
		savedMealTimeScheduleRemindersManager.clearBadges()
	}
}

extension PoedatorSavedMealTimeSchedulePresenter {
	func viewDidLoad() {
		configureUI()
	}

	func viewWillAppear() {
		savedMealTimeScheduleRemindersManager.clearBadges()

		Task { [weak self] in
			guard let self else {
				return
			}

			await self.savedMealTimeScheduleRemindersManager.removeAllDeliveredNotifications()
		}
	}

	func sectionModel(at sectionIndex: Int) -> PoedatorSavedMealTimeScheduleSection? {
		switch sectionIndex {
		case 0:
			return calculatedMealTimeScheduleSection

		default:
			assertionFailure("?")
			return nil
		}
	}

	func itemModel(
		by id: PoedatorSavedMealTimeScheduleItemIdentifier,
		at indexPath: IndexPath
	) -> (any ReusableTableViewItem)? {
		guard let section = sectionModel(at: indexPath.section) else {
			return nil
		}

		return section.items.first { $0.id == id }?.base
	}

	func headerItemModel(at sectionIndex: Int) -> (any ReusableTableViewHeaderFooterItem)? {
		guard let section = sectionModel(at: sectionIndex) else {
			return nil
		}

		return section.headerItem
	}

	func didTapAddRemindersButton() {
		addMealReminders()
	}

	func goToNextScreen() {
		coordinator.showCalculateMealTimeSchedule()
	}

	func didTapDeleteRemindersAndMealTimeScheduleButton() {
		notificationFeedbackGenerator.prepare()
		coordinator.didChangeScreenFeedbackGenerator.prepare()

		coordinator.showAlert(
			title: String(localized: "Attention"),
			message: String(localized: "Delete meal time reminders alert message"),
			yesActionStyle: .destructive,
			noActionStyle: .cancel,
			didTapYesAction: { [weak self] in
				self?.didTapWantDeleteRemindersAndMealTimeScheduleButton()
			},
			didTapNoAction: nil
		)

		coordinator.didChangeScreenFeedbackGenerator.impactOccurred()
	}
}

extension PoedatorSavedMealTimeSchedulePresenter: PoedatorCoordinatorDelegate {
	func didHideCalculateMealTimeScheduleScreen() {
		configureUI()
	}
}

extension PoedatorSavedMealTimeSchedulePresenter {
	func set(view: PoedatorSavedMealTimeScheduleVC) {
		self.view = view
	}
}

private extension PoedatorSavedMealTimeSchedulePresenter {
	func configureUI() {
		let calculatedMealTimeSchedule = userDefaultsFacade.mealTimeSchedule

		guard let firstMealTimeDate = calculatedMealTimeSchedule.first,
			  let lastMealTimeDate = calculatedMealTimeSchedule.last
		else {
			view?.showEmptyStateUI()
			return
		}

		if calculatedMealTimeSchedule == self.calculatedMealTimeSchedule {
			return
		}

		self.calculatedMealTimeSchedule = calculatedMealTimeSchedule

		let areAllMealTimeScheduleInSameDay = calendar.isDate(firstMealTimeDate, inSameDayAs: lastMealTimeDate)

		// swiftlint:disable:next force_try
		let calculatedMealTimeScheduleSection = try! assembly.calculatedMealTimeScheduleSection(
			for: calculatedMealTimeSchedule,
			areAllMealTimeScheduleInSameDay: areAllMealTimeScheduleInSameDay,
			calendar: calendar
		)
		self.calculatedMealTimeScheduleSection = calculatedMealTimeScheduleSection

		view?.showMealTimeScheduleUI()
		view?.set(snapshotData: [calculatedMealTimeScheduleSection.snapshotData])

		if userDefaultsFacade.areMealTimeScheduleRemindersAdded {
			view?.hideAddMealTimeRemindersButton()
		} else {
			view?.showAddMealTimeRemindersButton()
		}
	}

	func didTapWantDeleteRemindersAndMealTimeScheduleButton() {
		notificationFeedbackGenerator.prepare()

		savedMealTimeScheduleRemindersManager.clearBadges()
		Task { [weak self] in
			guard let self else {
				return
			}

			await self.savedMealTimeScheduleRemindersManager.removeAllDeliveredNotifications()
			await self.savedMealTimeScheduleRemindersManager.removeAllPendingNotificationRequests()
		}

		userDefaultsFacade.areMealTimeScheduleRemindersAdded = false
		userDefaultsFacade.mealTimeSchedule = []

		view?.showEmptyStateUI()

		notificationFeedbackGenerator.notificationOccurred(.success)
	}

	func addMealReminders() {
		Task { [weak self] in
			guard let self else {
				return
			}

			await self.savedMealTimeScheduleRemindersManager.removeAllDeliveredNotifications()
			await self.savedMealTimeScheduleRemindersManager.removeAllPendingNotificationRequests()
		}
		userDefaultsFacade.areMealTimeScheduleRemindersAdded = false

		notificationFeedbackGenerator.prepare()

		let task = Task { [weak self] in
			guard let self else {
				return
			}

			do {
				let wasGranted = try await self.savedMealTimeScheduleRemindersManager.requestUserNotificationAuthorization()
				if wasGranted {
					await self.didGrantUserNotificationAuthorization()
				} else {
					self.didNotGrantUserNotificationAuthorization()
				}
			} catch {
				assertionFailure(error.localizedDescription)
				self.notificationFeedbackGenerator.notificationOccurred(.error)
			}
		}

		tasks.append(task)
	}

	func didGrantUserNotificationAuthorization() async {
		let registeringMealTimeSchedule = userDefaultsFacade.mealTimeSchedule

		do {
			try await savedMealTimeScheduleRemindersManager.requestToAddMealReminders(for: registeringMealTimeSchedule)
			didAddMealReminders()
		} catch {
			assertionFailure(error.localizedDescription)
			notificationFeedbackGenerator.notificationOccurred(.error)
		}
	}

	func didAddMealReminders() {
		userDefaultsFacade.areMealTimeScheduleRemindersAdded = true

		view?.hideAddMealTimeRemindersButton()

		notificationFeedbackGenerator.notificationOccurred(.success)
	}

	func didNotGrantUserNotificationAuthorization() {
		coordinator.showAlert(
			title: String(localized: "Error"),
			message: String(localized: "Go to app notification settings alert message"),
			yesActionStyle: .default,
			noActionStyle: .destructive,
			didTapYesAction: { [weak self] in
				self?.coordinator.goToAppNotificationSettings()
			},
			didTapNoAction: nil
		)

		notificationFeedbackGenerator.notificationOccurred(.error)
	}
}
