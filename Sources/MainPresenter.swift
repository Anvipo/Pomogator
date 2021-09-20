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

	private var currentMealTimeList: [Date]
	private var poedatorSection: MainSection?

	private var currentMifflinStJeorKcNormalValue: Decimal?
	private var currentPersonSex: PersonSex?
	private var dailyCalorieIntakeMifflinStJeorKcNormalValueSection: MainSection?

	private var currentBodyMassIndex: Decimal?
	private var bodyMassIndexSection: MainSection?
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

		currentMealTimeList = []

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

		case 1:
			return dailyCalorieIntakeMifflinStJeorKcNormalValueSection

		case 2:
			return bodyMassIndexSection

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

	func footerItemModel(at sectionIndex: Int) -> (any ReusableTableViewHeaderFooterItem)? {
		guard let section = sectionModel(at: sectionIndex) else {
			return nil
		}

		return section.footerItem
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

		case .dailyCalorieIntakeMifflinStJeorKcNormalValue:
			coordinator.goToDailyCalorieIntake()

		case .bodyMassIndex:
			coordinator.goToBodyMassIndex()
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

		let dailyCalorieIntakeMifflinStJeorKcNormalValueSection = makeDailyCalorieIntakeMifflinStJeorKcNormalValueSection()
		self.dailyCalorieIntakeMifflinStJeorKcNormalValueSection = dailyCalorieIntakeMifflinStJeorKcNormalValueSection

		let bodyMassIndexSection = makeBodyMassIndexSection()
		self.bodyMassIndexSection = bodyMassIndexSection

		let snapshotData = [
			poedatorSection.snapshotData,
			dailyCalorieIntakeMifflinStJeorKcNormalValueSection.snapshotData,
			bodyMassIndexSection.snapshotData
		]

		view?.set(snapshotData: snapshotData)
	}

	func makePoedatorSection() -> MainSection {
		let calculatedMealTimeList = userDefaultsFacade.calculatedMealTimeList

		guard let firstMealTimeDate = calculatedMealTimeList.first,
			  let lastMealTimeDate = calculatedMealTimeList.last
		else {
			return assembly.emptyPoedatorSection
		}

		if calculatedMealTimeList == currentMealTimeList {
			// swiftlint:disable:next force_unwrapping
			return poedatorSection!
		}

		currentMealTimeList = calculatedMealTimeList

		let isMealTimeListInSameDay = calendar.isDate(firstMealTimeDate, inSameDayAs: lastMealTimeDate)

		return assembly.poedatorSection(
			for: calculatedMealTimeList,
			isMealTimeListInSameDay: isMealTimeListInSameDay
		)
	}

	func makeDailyCalorieIntakeMifflinStJeorKcNormalValueSection() -> MainSection {
		let calculatedMifflinStJeorKcNormalValue = userDefaultsFacade.calculatedMifflinStJeorKcNormalValue
		let selectedPersonSex: PersonSex?
		if let inputedDailyCalorieIntakeSelectedPersonSexIndex = userDefaultsFacade
			.inputedDailyCalorieIntakeSelectedPersonSexIndex
			.flatMap(Int.init(_:)) {
			selectedPersonSex = PersonSex.allCases[inputedDailyCalorieIntakeSelectedPersonSexIndex]
		} else {
			selectedPersonSex = nil
		}

		if calculatedMifflinStJeorKcNormalValue == nil && selectedPersonSex == nil {
			return assembly.mifflinStJeorKcNormalValueSection(
				calculatedMifflinStJeorKcNormalValue: nil,
				selectedPersonSex: nil
			)
		}

		if selectedPersonSex == currentPersonSex &&
		   calculatedMifflinStJeorKcNormalValue == currentMifflinStJeorKcNormalValue {
			// swiftlint:disable:next force_unwrapping
			return dailyCalorieIntakeMifflinStJeorKcNormalValueSection!
		}

		currentMifflinStJeorKcNormalValue = calculatedMifflinStJeorKcNormalValue
		currentPersonSex = selectedPersonSex

		return assembly.mifflinStJeorKcNormalValueSection(
			calculatedMifflinStJeorKcNormalValue: calculatedMifflinStJeorKcNormalValue,
			selectedPersonSex: selectedPersonSex
		)
	}

	func makeBodyMassIndexSection() -> MainSection {
		let calculatedBodyMassIndex = userDefaultsFacade.calculatedBodyMassIndex

		if calculatedBodyMassIndex == nil {
			return assembly.bodyMassIndexSection(calculatedBodyMassIndex: nil)
		}

		if calculatedBodyMassIndex == currentBodyMassIndex {
			// swiftlint:disable:next force_unwrapping
			return bodyMassIndexSection!
		}

		currentBodyMassIndex = calculatedBodyMassIndex

		return assembly.bodyMassIndexSection(calculatedBodyMassIndex: calculatedBodyMassIndex)
	}
}
