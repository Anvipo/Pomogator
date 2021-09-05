//
//  MainPresenter.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit

final class MainPresenter: BasePresenter {
	private let assembly: MainAssembly
	private let calendar: Calendar
	private let coordinator: MainCoordinator
	private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
	private let poedatorUserDefaultsFacade: PoedatorUserDefaultsFacade

	private var currentSavedMealTimeSchedule: PoedatorMealTimeSchedule
	private var poedatorSection: MainSection?
	private weak var view: MainVC?

	init(
		assembly: MainAssembly,
		calendar: Calendar,
		coordinator: MainCoordinator,
		notificationFeedbackGenerator: UINotificationFeedbackGenerator,
		poedatorUserDefaultsFacade: PoedatorUserDefaultsFacade
	) {
		self.assembly = assembly
		self.calendar = calendar
		self.coordinator = coordinator
		self.notificationFeedbackGenerator = notificationFeedbackGenerator
		self.poedatorUserDefaultsFacade = poedatorUserDefaultsFacade

		currentSavedMealTimeSchedule = []

		super.init(baseCoordinator: coordinator)
	}

	override func baseViewDidAppear() {
		super.baseViewDidAppear()
		notificationFeedbackGenerator.prepare()
	}
}

extension MainPresenter {
	func viewWillAppear() {
		configureUI()
	}

	func sectionModel(at sectionIndex: Int) -> MainSection? {
		switch sectionIndex {
		case 0:
			return poedatorSection

		default:
			assertionFailure("?")
			return nil
		}
	}

	func itemModel(
		by id: MainItemIdentifier,
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

	func didTapItem(with itemIdentifier: MainItemIdentifier, at indexPath: IndexPath) {
		guard itemModel(by: itemIdentifier, at: indexPath) != nil else {
			assertionFailure("?")
			return
		}

		coordinator.didChangeScreenFeedbackGenerator.prepare()

		switch itemIdentifier {
		case .poedator:
			coordinator.goToPoedator()
		}
	}
}

extension MainPresenter {
	func set(view: MainVC) {
		self.view = view
	}
}

private extension MainPresenter {
	func configureUI() {
		let poedatorSection = makePoedatorSection()
		self.poedatorSection = poedatorSection

		let snapshotData = [
			poedatorSection.snapshotData
		]

		view?.set(snapshotData: snapshotData)
	}

	func makePoedatorSection() -> MainSection {
		let savedMealTimeSchedule = poedatorUserDefaultsFacade.mealTimeSchedule

		guard let firstMealTimeDate = savedMealTimeSchedule.first,
			  let lastMealTimeDate = savedMealTimeSchedule.last
		else {
			return assembly.emptyPoedatorSection
		}

		if lastMealTimeDate.timeIntervalSinceNow < 0 {
			return assembly.emptyPoedatorForTodaySection
		}

		if savedMealTimeSchedule == currentSavedMealTimeSchedule {
			// swiftlint:disable:next force_unwrapping
			return poedatorSection!
		}

		currentSavedMealTimeSchedule = savedMealTimeSchedule

		let isMealTimeScheduleInSameDay = calendar.isDate(firstMealTimeDate, inSameDayAs: lastMealTimeDate)

		return assembly.poedatorSection(
			for: savedMealTimeSchedule,
			isMealTimeScheduleInSameDay: isMealTimeScheduleInSameDay
		)
	}
}
