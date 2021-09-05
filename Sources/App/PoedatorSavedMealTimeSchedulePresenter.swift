//
//  PoedatorSavedMealTimeSchedulePresenter.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit
import WidgetKit

final class PoedatorSavedMealTimeSchedulePresenter: BasePresenter {
	private let bundle: Bundle
	private let coordinator: PoedatorCoordinator
	private let savedMealTimeScheduleRemindersManager: PoedatorSavedMealTimeScheduleRemindersManager
	private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
	private let poedatorMealTimeScheduleStoreFacade: IPoedatorMealTimeScheduleStoreFacade
	private let viewModelFactory: PoedatorSavedMealTimeScheduleViewModelFactory
	private let watchConnectivityFacade: WatchConnectivityFacade
	private let widgetCenter: WidgetCenter

	private var calculatedMealTimeSchedule: PoedatorMealTimeSchedule
	private var calculatedMealTimeScheduleSection: PoedatorSavedMealTimeScheduleSection?
	private weak var view: PoedatorSavedMealTimeScheduleVC?

	init(
		bundle: Bundle,
		coordinator: PoedatorCoordinator,
		savedMealTimeScheduleRemindersManager: PoedatorSavedMealTimeScheduleRemindersManager,
		notificationFeedbackGenerator: UINotificationFeedbackGenerator,
		poedatorMealTimeScheduleStoreFacade: IPoedatorMealTimeScheduleStoreFacade,
		viewModelFactory: PoedatorSavedMealTimeScheduleViewModelFactory,
		watchConnectivityFacade: WatchConnectivityFacade,
		widgetCenter: WidgetCenter
	) {
		self.viewModelFactory = viewModelFactory
		self.bundle = bundle
		self.coordinator = coordinator
		self.savedMealTimeScheduleRemindersManager = savedMealTimeScheduleRemindersManager
		self.notificationFeedbackGenerator = notificationFeedbackGenerator
		self.poedatorMealTimeScheduleStoreFacade = poedatorMealTimeScheduleStoreFacade
		self.watchConnectivityFacade = watchConnectivityFacade
		self.widgetCenter = widgetCenter

		calculatedMealTimeSchedule = []
	}
}

extension PoedatorSavedMealTimeSchedulePresenter {
	func viewDidLoad() {
		watchConnectivityFacade.start()

		observeScheduleUpdates()

		guard let nextMealTime else {
			return
		}

		view?.scroll(to: .calculatedMealTime(nextMealTime, isNext: true), at: .bottom)
	}

	func viewWillAppear() {
		onAppear()
	}

	func sceneWillEnterForeground() {
		onAppear()
	}

	func didTapAddRemindersButton() {
		if calculatedMealTimeSchedule.isEmpty {
			assertionFailure("?")
			return
		}

		addMealReminders()
	}

	func didTapChangeMealTimeScheduleButton() {
		coordinator.showCalculateMealTimeSchedule(fromRestore: false)
	}

	func didTapDeleteRemindersAndMealTimeScheduleButton() {
		notificationFeedbackGenerator.prepare()

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
	}
}

extension PoedatorSavedMealTimeSchedulePresenter: IBaseViewOutput {}

extension PoedatorSavedMealTimeSchedulePresenter: IBaseTableViewOutput {
	func sectionModel(at sectionIndex: Int) -> PoedatorSavedMealTimeScheduleSection? {
		if sectionIndex == 0 {
			return calculatedMealTimeScheduleSection
		}

		fatalError("?")
	}
}

extension PoedatorSavedMealTimeSchedulePresenter: IPoedatorCoordinatorDelegate {
	func didUpdateMealTimeSchedule() {
		configureUI()
	}
}

extension PoedatorSavedMealTimeSchedulePresenter {
	func set(view: PoedatorSavedMealTimeScheduleVC) {
		self.view = view
	}
}

private extension PoedatorSavedMealTimeSchedulePresenter {
	var nextMealTime: Date? {
		calculatedMealTimeSchedule.nextMealTime
	}

	func updateNextMealTimeBackgroundItem() {
		guard let calculatedMealTimeScheduleSection,
			  calculatedMealTimeScheduleSection.items.isNotEmpty
		else {
			return
		}

		for itemIndex in calculatedMealTimeScheduleSection.items.indices {
			var newItem = calculatedMealTimeScheduleSection.castedItems[itemIndex]
			if let nextMealTime, newItem.id.calculatedMealTime == nextMealTime {
				newItem.backgroundColorHandler = { _ in ColorStyle.brand.color }
				newItem.textProperties.color = ColorStyle.labelOnBrand.color
				newItem.id = newItem.id.copy(newIsNext: true)
			} else {
				newItem.backgroundColorHandler = nil
				newItem.id = newItem.id.copy(newIsNext: false)
			}
			self.calculatedMealTimeScheduleSection!.castedItems[itemIndex] = newItem
		}

		let newCalculatedMealTimeScheduleSection = self.calculatedMealTimeScheduleSection!

		view?.set(snapshotData: [newCalculatedMealTimeScheduleSection.snapshotData])
	}
}

private extension PoedatorSavedMealTimeSchedulePresenter {
	func onAppear() {
		let task = Task { [weak savedMealTimeScheduleRemindersManager] in
			try await savedMealTimeScheduleRemindersManager?.clearBadges()
			await savedMealTimeScheduleRemindersManager?.removeAllDeliveredNotifications()
		}
		tasks.append(task)

		configureUI()
	}

	func configureUI() {
		guard let view else {
			assertionFailure("?")
			return
		}

		let calculatedMealTimeSchedule = poedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.iCloud, .sharedLocal])

		if calculatedMealTimeSchedule.isOutdated && poedatorMealTimeScheduleStoreFacade.shouldAutoDeleteMealSchedule {
			view.hideAddMealTimeRemindersButton()
			deleteRemindersAndMealTimeSchedule()
			return
		}

		guard calculatedMealTimeSchedule.isNotEmpty else {
			view.showEmptyStateUI(completion: nil)
			view.hideAddMealTimeRemindersButton()
			return
		}

		if calculatedMealTimeSchedule == self.calculatedMealTimeSchedule {
			updateNextMealTimeBackgroundItem()
			return
		}

		self.calculatedMealTimeSchedule = calculatedMealTimeSchedule

		let calculatedMealTimeScheduleSection = try! viewModelFactory.calculatedMealTimeScheduleSection(for: calculatedMealTimeSchedule)
		self.calculatedMealTimeScheduleSection = calculatedMealTimeScheduleSection

		view.set(snapshotData: [calculatedMealTimeScheduleSection.snapshotData])
		view.showMealTimeScheduleUI()

		if poedatorMealTimeScheduleStoreFacade.areMealTimeScheduleRemindersAdded || calculatedMealTimeSchedule.isOutdated {
			view.hideAddMealTimeRemindersButton()
		} else {
			view.showAddMealTimeRemindersButton()
		}
	}

	func didTapWantDeleteRemindersAndMealTimeScheduleButton() {
		notificationFeedbackGenerator.prepare()

		deleteRemindersAndMealTimeSchedule()

		notificationFeedbackGenerator.notificationOccurred(.success)
		view?.accessibilityNotificateAboutEmptyState()
	}

	func deleteRemindersAndMealTimeSchedule() {
		guard let view else {
			assertionFailure("?")
			return
		}

		let task = Task { [weak savedMealTimeScheduleRemindersManager] in
			try await savedMealTimeScheduleRemindersManager?.clearBadges()
			await savedMealTimeScheduleRemindersManager?.removeAllDeliveredNotifications()
			await savedMealTimeScheduleRemindersManager?.removeAllPendingNotificationRequests()
		}
		tasks.append(task)

		poedatorMealTimeScheduleStoreFacade.areMealTimeScheduleRemindersAdded = false
		poedatorMealTimeScheduleStoreFacade.save(poedatorMealTimeSchedule: [], to: [.iCloud, .sharedLocal])
		poedatorMealTimeScheduleStoreFacade.shouldAutoDeleteMealSchedule = false

		calculatedMealTimeSchedule = []
		calculatedMealTimeScheduleSection = nil

		view.showEmptyStateUI { [weak view] _ in
			view?.set(snapshotData: [])
		}
		view.hideAddMealTimeRemindersButton()

		coordinator.resetCalculateMealTimeSchedule()

		widgetCenter.reloadTimelines(ofKind: .poedatorAppWidgetKind)

		watchConnectivityFacade.send(mealTimeSchedule: [])
	}

	func addMealReminders() {
		let removeAllNotificationsTask = Task { [weak savedMealTimeScheduleRemindersManager] in
			await savedMealTimeScheduleRemindersManager?.removeAllDeliveredNotifications()
			await savedMealTimeScheduleRemindersManager?.removeAllPendingNotificationRequests()
		}
		tasks.append(removeAllNotificationsTask)
		poedatorMealTimeScheduleStoreFacade.areMealTimeScheduleRemindersAdded = false

		notificationFeedbackGenerator.prepare()

		let requestUserNotificationAuthorizationTask = Task { [weak self] in
			guard let self else {
				return
			}

			do {
				let wasGranted = try await savedMealTimeScheduleRemindersManager.requestUserNotificationAuthorization()
				if wasGranted {
					await didGrantUserNotificationAuthorization()
				} else {
					didNotGrantUserNotificationAuthorization()
				}
			} catch {
				didNotGrantUserNotificationAuthorization()
			}
		}
		tasks.append(requestUserNotificationAuthorizationTask)
	}

	func didGrantUserNotificationAuthorization() async {
		let registeringMealTimeSchedule = poedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.iCloud, .sharedLocal])

		do {
			try await savedMealTimeScheduleRemindersManager.requestToAddMealReminders(for: registeringMealTimeSchedule)
			didAddMealReminders()
		} catch {
			assertionFailure(error.localizedDescription)
			notificationFeedbackGenerator.notificationOccurred(.error)
		}
	}

	func didAddMealReminders() {
		poedatorMealTimeScheduleStoreFacade.areMealTimeScheduleRemindersAdded = true

		view?.hideAddMealTimeRemindersButton()

		notificationFeedbackGenerator.notificationOccurred(.success)
		view?.accessibilityNotificateAboutDidAddNotifications()

		poedatorMealTimeScheduleStoreFacade.mealTimeScheduleRemindersAddedCount += 1
		let currentMealTimeScheduleRemindersAddedCount = poedatorMealTimeScheduleStoreFacade.mealTimeScheduleRemindersAddedCount

		let currentAppVersion = bundle.currentVersion
		let lastVersionPromptedForReview = poedatorMealTimeScheduleStoreFacade.lastVersionPromptedForReview

		guard currentAppVersion != lastVersionPromptedForReview && currentMealTimeScheduleRemindersAddedCount >= 5 else {
			return
		}

		let requestReviewTask = Task { [weak self] in
			guard let self else {
				return
			}

			try? await Task.sleep(for: .seconds(2))

			coordinator.requestReview()
			poedatorMealTimeScheduleStoreFacade.lastVersionPromptedForReview = currentAppVersion
		}
		tasks.append(requestReviewTask)
	}

	func didNotGrantUserNotificationAuthorization() {
		coordinator.showErrorAlert(
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

	func observeScheduleUpdates() {
		observeDidChangeExternallyNotification { [weak self] result in
			guard let self,
				  let notification = result.value,
				  notification.keys.contains(.poedatorMealTimeScheduleKey) else {
				return
			}

			self.handleChangedExternallySchedule()

			self.configureUI()
		}
	}

	func handleChangedExternallySchedule() {
		let poedatorMealTimeSchedule = poedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.iCloud])
		poedatorMealTimeScheduleStoreFacade.save(poedatorMealTimeSchedule: poedatorMealTimeSchedule, to: [.sharedLocal])

		widgetCenter.reloadTimelines(ofKind: .poedatorAppWidgetKind)
	}
}
