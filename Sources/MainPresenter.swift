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
	private let userDefaultsFacade: UserDefaultsFacade

	private var calculatedMealTimeList: [Date]
	private var poedatorSection: MainSection?
	private weak var view: MainVC?

	init(
		assembly: MainAssembly,
		calendar: Calendar,
		coordinator: MainCoordinator,
		notificationFeedbackGenerator: UINotificationFeedbackGenerator,
		userDefaultsFacade: UserDefaultsFacade
	) {
		self.assembly = assembly
		self.calendar = calendar
		self.coordinator = coordinator
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

extension MainPresenter {
	func viewDidLoad() {
		configureUI()
	}

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
	) -> AnyMainTableItem? {
		guard let section = sectionModel(at: indexPath.section) else {
			return nil
		}

		return section.items.first { $0.id == id }
	}

	func headerItemModel(at sectionIndex: Int) -> TableViewHeaderFooterItemProtocol? {
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

		view?.set(snapshotData: [poedatorSection.snapshotData].compactMap { $0 })
	}

	func makePoedatorSection() -> MainSection {
		let calculatedMealTimeList = userDefaultsFacade.calculatedMealTimeList

		guard let firstMealTimeDate = calculatedMealTimeList.first,
			  let lastMealTimeDate = calculatedMealTimeList.last
		else {
			return assembly.emptyPoedatorSection
		}

		if calculatedMealTimeList == self.calculatedMealTimeList {
			// swiftlint:disable:next force_unwrapping
			return poedatorSection!
		}

		self.calculatedMealTimeList = calculatedMealTimeList

		let isMealTimeListInSameDay = calendar.isDate(firstMealTimeDate, inSameDayAs: lastMealTimeDate)

		return assembly.poedatorSection(
			for: firstMealTimeDate,
			isMealTimeListInSameDay: isMealTimeListInSameDay
		)
	}
}
