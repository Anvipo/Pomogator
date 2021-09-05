//
//  PoedatorYourMealTimeListPresenter.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class PoedatorYourMealTimeListPresenter: BasePresenter {
	private let assembly: PoedatorYourMealTimeListAssembly
	private let calendar: Calendar
	private let coordinator: PoedatorCoordinator
	private let mealRemindersManager: PoedatorMealRemindersManager
	private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
	private let userDefaultsFacade: UserDefaultsFacade

	private var calculatedMealTimeList: [Date]
	private var calculatedMealTimeListSection: PoedatorYourMealTimeListSection?
	private weak var view: PoedatorYourMealTimeListVC?

	init(
		assembly: PoedatorYourMealTimeListAssembly,
		calendar: Calendar,
		coordinator: PoedatorCoordinator,
		mealRemindersManager: PoedatorMealRemindersManager,
		notificationFeedbackGenerator: UINotificationFeedbackGenerator,
		userDefaultsFacade: UserDefaultsFacade
	) {
		self.assembly = assembly
		self.calendar = calendar
		self.coordinator = coordinator
		self.mealRemindersManager = mealRemindersManager
		self.notificationFeedbackGenerator = notificationFeedbackGenerator
		self.userDefaultsFacade = userDefaultsFacade

		calculatedMealTimeList = []

		super.init(baseCoordinator: coordinator)
	}

	override func baseViewDidAppear() {
		super.baseViewDidAppear()
		notificationFeedbackGenerator.prepare()
	}
}

extension PoedatorYourMealTimeListPresenter {
	func viewDidLoad() {
		configureUI()
	}

	func viewWillAppear() {
		mealRemindersManager.clearBadges()
		mealRemindersManager.removeAllDeliveredNotifications()
	}

	func sectionModel(at sectionIndex: Int) -> PoedatorYourMealTimeListSection? {
		switch sectionIndex {
		case 0:
			return calculatedMealTimeListSection

		default:
			assertionFailure("?")
			return nil
		}
	}

	func itemModel(
		by id: PoedatorYourMealTimeListItemIdentifier,
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
		coordinator.showCalculateMealTimeList(delegate: self)
	}

	func didTapDeleteRemindersAndMealTimeListButton() {
		notificationFeedbackGenerator.prepare()
		coordinator.didChangeScreenFeedbackGenerator.prepare()

		coordinator.showAlert(
			title: String(localized: "Attention"),
			message: String(localized: "Do you want to delete all calculated meal times?"),
			yesActionStyle: .destructive,
			noActionStyle: .cancel,
			didTapYesAction: { [weak self] in
				self?.didTapWantDeleteRemindersAndMealTimeListButton()
			},
			didTapNoAction: nil
		)

		coordinator.didChangeScreenFeedbackGenerator.impactOccurred()
	}
}

extension PoedatorYourMealTimeListPresenter: PoedatorCoordinatorDelegate {
	func didHideCalculateMealTimeListScreen() {
		configureUI()
	}
}

extension PoedatorYourMealTimeListPresenter {
	func set(view: PoedatorYourMealTimeListVC) {
		self.view = view
	}
}

private extension PoedatorYourMealTimeListPresenter {
	func configureUI() {
		let calculatedMealTimeList = userDefaultsFacade.calculatedMealTimeList

		guard let firstMealTimeDate = calculatedMealTimeList.first,
			  let lastMealTimeDate = calculatedMealTimeList.last
		else {
			view?.showEmptyStateUI()
			return
		}

		if calculatedMealTimeList == self.calculatedMealTimeList {
			return
		}

		self.calculatedMealTimeList = calculatedMealTimeList

		let isMealTimeListInSameDay = calendar.isDate(firstMealTimeDate, inSameDayAs: lastMealTimeDate)

		// swiftlint:disable:next force_try
		let calculatedMealTimeListSection = try! assembly.calculatedMealTimeListSection(
			for: calculatedMealTimeList,
			isMealTimeListInSameDay: isMealTimeListInSameDay
		)
		self.calculatedMealTimeListSection = calculatedMealTimeListSection

		view?.showMealTimeListUI()
		view?.set(snapshotData: [calculatedMealTimeListSection.snapshotData])

		if userDefaultsFacade.areMealTimeRemindersAdded {
			view?.hideAddMealTimeRemindersButton()
		} else {
			view?.showAddMealTimeRemindersButton()
		}
	}

	func didTapWantDeleteRemindersAndMealTimeListButton() {
		notificationFeedbackGenerator.prepare()

		mealRemindersManager.clearBadges()
		mealRemindersManager.removeAllDeliveredNotifications()
		mealRemindersManager.removeAllPendingNotificationRequests()

		userDefaultsFacade.areMealTimeRemindersAdded = false
		userDefaultsFacade.calculatedMealTimeList = []
		userDefaultsFacade.inputedNumberOfMealTimes = nil
		userDefaultsFacade.inputedFirstMealTime = nil
		userDefaultsFacade.inputedLastMealTime = nil

		view?.showEmptyStateUI()

		notificationFeedbackGenerator.notificationOccurred(.success)
	}

	func addMealReminders() {
		mealRemindersManager.removeAllDeliveredNotifications()
		mealRemindersManager.removeAllPendingNotificationRequests()
		userDefaultsFacade.areMealTimeRemindersAdded = false

		notificationFeedbackGenerator.prepare()

		let task = Task { [weak self] in
			guard let self else {
				return
			}

			do {
				let wasGranted = try await self.mealRemindersManager.requestUserNotificationAuthorization()
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
		let registeringMealTimeList = userDefaultsFacade.calculatedMealTimeList

		do {
			try await mealRemindersManager.requestToAddMealReminders(for: registeringMealTimeList)
			didAddMealReminders()
		} catch {
			assertionFailure(error.localizedDescription)
			notificationFeedbackGenerator.notificationOccurred(.error)
		}
	}

	func didAddMealReminders() {
		userDefaultsFacade.areMealTimeRemindersAdded = true

		view?.hideAddMealTimeRemindersButton()

		notificationFeedbackGenerator.notificationOccurred(.success)
	}

	func didNotGrantUserNotificationAuthorization() {
		coordinator.showAlert(
			title: String(localized: "Error"),
			message: String(localized: "You don't give permission to send notifications"),
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
