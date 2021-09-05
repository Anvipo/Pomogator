//
//  PoedatorCalculateMealTimeListPresenter.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//
// swiftlint:disable file_length

import UIKit

final class PoedatorCalculateMealTimeListPresenter: BasePresenter {
	private let assembly: PoedatorCalculateMealTimeListAssembly
	private let calendar: Calendar
	private let coordinator: PoedatorCoordinator
	private let didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
	private let userDefaultsFacade: UserDefaultsFacade

	private var inputedNumberOfMealTimes: UInt?
	private var inputedFirstMealTime: Date?
	private var inputedLastMealTime: Date?

	private var currentCalculatedMealTimeList: [Date]

	private var numberOfMealTimesItem: StringFieldItem<PoedatorCalculateMealTimeListItemIdentifier>?
	private var firstMealTimeItem: DateFieldItem<PoedatorCalculateMealTimeListItemIdentifier>?
	private var lastMealTimeItem: DateFieldItem<PoedatorCalculateMealTimeListItemIdentifier>?

	private var parametersSection: PoedatorCalculateMealTimeListSection?
	private var calculatedMealTimeListSection: PoedatorCalculateMealTimeListSection?

	private weak var view: PoedatorCalculateMealTimeListVC?

	init(
		assembly: PoedatorCalculateMealTimeListAssembly,
		calendar: Calendar,
		coordinator: PoedatorCoordinator,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		notificationFeedbackGenerator: UINotificationFeedbackGenerator,
		inputedNumberOfMealTimes: UInt?,
		inputedFirstMealTime: Date?,
		inputedLastMealTime: Date?,
		userDefaultsFacade: UserDefaultsFacade
	) {
		self.assembly = assembly
		self.calendar = calendar
		self.coordinator = coordinator
		self.didTapBarButtonItemFeedbackGenerator = didTapBarButtonItemFeedbackGenerator
		self.notificationFeedbackGenerator = notificationFeedbackGenerator
		self.inputedNumberOfMealTimes = inputedNumberOfMealTimes
		self.inputedFirstMealTime = inputedFirstMealTime
		self.inputedLastMealTime = inputedLastMealTime
		self.userDefaultsFacade = userDefaultsFacade

		currentCalculatedMealTimeList = []

		super.init(baseCoordinator: coordinator)
	}

	override func baseViewDidAppear() {
		super.baseViewDidAppear()
		notificationFeedbackGenerator.prepare()
		didTapBarButtonItemFeedbackGenerator.prepare()
	}
}

extension PoedatorCalculateMealTimeListPresenter {
	func viewDidLoad() {
		let (numberOfMealTimesItem, parametersSection) = assembly.parametersSection(
			inputedNumberOfMealTimes: inputedNumberOfMealTimes,
			stringFieldItemDelegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)
		self.numberOfMealTimesItem = numberOfMealTimesItem
		self.parametersSection = parametersSection

		configureUI(changingItemID: nil)
	}

	func sectionModel(at sectionIndex: Int) -> PoedatorCalculateMealTimeListSection? {
		switch sectionIndex {
		case 0:
			return parametersSection

		case 1:
			return calculatedMealTimeListSection

		default:
			assertionFailure("?")
			return nil
		}
	}

	func itemModel(
		by id: PoedatorCalculateMealTimeListItemIdentifier,
		at indexPath: IndexPath
	) -> AnyPoedatorCalculateMealTimeListTableItem? {
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

	func didTapSaveButton() {
		userDefaultsFacade.calculatedMealTimeList = calculateMealTimeList()
		userDefaultsFacade.areMealTimeRemindersAdded = false
		userDefaultsFacade.inputedNumberOfMealTimes = inputedNumberOfMealTimes
		userDefaultsFacade.inputedFirstMealTime = inputedFirstMealTime
		userDefaultsFacade.inputedLastMealTime = inputedLastMealTime

		notificationFeedbackGenerator.notificationOccurred(.success)

		coordinator.hideCalculateMealTimeList()
	}
}

extension PoedatorCalculateMealTimeListPresenter: StringFieldItemDelegate {
	func stringFieldItem<ID: Hashable>(
		_ item: StringFieldItem<ID>,
		shouldChangeCharactersIn range: Range<String.Index>,
		replacementString: String
	) -> Bool {
		guard let itemID = item.id as? PoedatorCalculateMealTimeListItemIdentifier else {
			assertionFailure("?")
			return false
		}

		if itemID != .numberOfMealTime {
			assertionFailure("?")
			return true
		}

		notificationFeedbackGenerator.prepare()

		func feedbackWrongText() {
			notificationFeedbackGenerator.notificationOccurred(.error)
			notificationFeedbackGenerator.prepare()
		}

		let currentText = item.content.text
		let possibleString = currentText.replacingCharacters(in: range, with: replacementString)

		if possibleString.isEmpty {
			return true
		}

		let possibleNumber: UInt
		do {
			possibleNumber = try UInt(possibleString, format: .number)
		} catch {
			return false
		}

		let shouldChange = 2...9 ~= possibleNumber

		if !shouldChange {
			feedbackWrongText()
		}

		return shouldChange
	}

	func stringFieldItemFormattedString<ID: Hashable>(
		_ item: StringFieldItem<ID>
	) -> String {
		guard let itemID = item.id as? PoedatorCalculateMealTimeListItemIdentifier else {
			assertionFailure("?")
			return ""
		}

		let currentText = item.content.text

		if itemID != .numberOfMealTime {
			assertionFailure("?")
			return currentText
		}

		if currentText.isEmpty {
			return ""
		}

		let inputedNumberOfMealTimes: UInt
		do {
			inputedNumberOfMealTimes = try UInt(currentText, format: .number)
		} catch {
			return ""
		}

		return inputedNumberOfMealTimes.formatted(.number)
	}

	func stringFieldItemDidChangeString<ID: Hashable>(
		_ item: StringFieldItem<ID>
	) {
		guard let itemID = item.id as? PoedatorCalculateMealTimeListItemIdentifier else {
			assertionFailure("?")
			return
		}

		if itemID != .numberOfMealTime {
			assertionFailure("?")
			return
		}

		let newText = item.content.text

		didTapBarButtonItemFeedbackGenerator.prepare()
		numberOfMealTimesItem?.content.text = newText

		if newText.isEmpty {
			inputedNumberOfMealTimes = nil
			currentCalculatedMealTimeList = []
		} else {
			do {
				inputedNumberOfMealTimes = try UInt(newText, format: .number)
			} catch {
				assertionFailure(error.localizedDescription)
				return
			}
		}

		didTapBarButtonItemFeedbackGenerator.prepare()

		configureUI(changingItemID: itemID)
	}
}

extension PoedatorCalculateMealTimeListPresenter: DateFieldItemDelegate {
	func dateFieldItem<ID: Hashable>(
		_ item: DateFieldItem<ID>,
		shouldChangeTo newDate: Date
	) -> Bool {
		guard let itemID = item.id as? PoedatorCalculateMealTimeListItemIdentifier else {
			assertionFailure("?")
			return false
		}

		switch itemID {
		case .firstMealTime:
			return shouldChangeDateForFirstMealTimeItem(newDate: newDate)

		case .lastMealTime:
			return shouldChangeDateForLastMealTimeItem(newDate: newDate)

		default:
			assertionFailure("?")
			return true
		}
	}

	func dateFieldItemDidChangeDate<ID: Hashable>(_ item: DateFieldItem<ID>) {
		guard let itemID = item.id as? PoedatorCalculateMealTimeListItemIdentifier else {
			assertionFailure("?")
			return
		}

		let newDate = item.content.date

		switch itemID {
		case .firstMealTime:
			assert(firstMealTimeItem != nil)
			firstMealTimeItem?.content.date = newDate
			inputedFirstMealTime = newDate

		case .lastMealTime:
			assert(lastMealTimeItem != nil)
			lastMealTimeItem?.content.date = newDate
			inputedLastMealTime = newDate

		default:
			assertionFailure("?")
		}

		didTapBarButtonItemFeedbackGenerator.prepare()

		configureUI(changingItemID: itemID)
	}
}

extension PoedatorCalculateMealTimeListPresenter: FieldItemDelegate {
	func fieldItemDidBeginEditing<ID: Hashable>(_ item: FieldItem<ID>) {
		guard item.id is PoedatorCalculateMealTimeListItemIdentifier else {
			assertionFailure("?")
			return
		}

		notificationFeedbackGenerator.prepare()
		didTapBarButtonItemFeedbackGenerator.prepare()
	}
}

extension PoedatorCalculateMealTimeListPresenter {
	func set(view: PoedatorCalculateMealTimeListVC) {
		self.view = view
	}
}

private extension PoedatorCalculateMealTimeListPresenter {
	func configureUI(changingItemID: PoedatorCalculateMealTimeListItemIdentifier?) {
		configureParametersSection(changingItemID: changingItemID)
		configureCalculatedMealTimeListSection()

		let snapshotData = [
			parametersSection?.snapshotData,
			calculatedMealTimeListSection?.snapshotData
		].compactMap { $0 }

		view?.set(snapshotData: snapshotData)
	}

	func makeFirstMealTimeItem() -> DateFieldItem<PoedatorCalculateMealTimeListItemIdentifier> {
		assembly.firstMealTimeItem(
			inputedFirstMealTime: inputedFirstMealTime,
			getFirstMealTimeText: { [weak self] newFirstMealTime in
				guard let self else {
					return ""
				}

				return self.convert(mealTime: newFirstMealTime)
			},
			getFirstMealTime: { [weak self] newFirstMealTimeText in
				self?.convert(mealTimeText: newFirstMealTimeText)
			},
			calendar: calendar,
			dateFieldItemDelegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)
	}

	func makeLastMealTimeItem() -> DateFieldItem<PoedatorCalculateMealTimeListItemIdentifier> {
		assembly.lastMealTimeItem(
			inputedLastMealTime: inputedLastMealTime,
			getLastMealTimeText: { [weak self] newLastMealTime in
				guard let self else {
					return ""
				}

				return self.convert(mealTime: newLastMealTime)
			},
			getLastMealTime: { [weak self] newLastMealTimeText in
				self?.convert(mealTimeText: newLastMealTimeText)
			},
			calendar: calendar,
			dateFieldItemDelegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)
	}

	func configureParametersSection(changingItemID: PoedatorCalculateMealTimeListItemIdentifier?) {
		assert(parametersSection != nil)
		assert(numberOfMealTimesItem != nil)

		defer {
			let items = [
				numberOfMealTimesItem?.eraseToAnyTableItem(),
				firstMealTimeItem?.eraseToAnyTableItem(),
				lastMealTimeItem?.eraseToAnyTableItem()
			]

			parametersSection?.items = items.compactMap { $0 }
		}

		guard let changingItemID else {
			if inputedNumberOfMealTimes != nil && inputedFirstMealTime != nil && inputedFirstMealTime != nil {
				// зашли на экран с сохранёнными параметрами
				setupFirstMealTimeItem()
				setupLastMealTimeItem()
				numberOfMealTimesItem?.respondersNavigationFacade?.barButtonItems.forEach { $0.isHidden = false }
			} else {
				// пустой экран
				numberOfMealTimesItem?.respondersNavigationFacade?.barButtonItems.forEach { $0.isHidden = true }
			}

			return
		}

		switch changingItemID {
		case .numberOfMealTime:
			if inputedNumberOfMealTimes != nil && firstMealTimeItem == nil {
				// впервые ввели количество приёмов пищи
				setupFirstMealTimeItem()
				numberOfMealTimesItem?.respondersNavigationFacade?.barButtonItems.forEach { $0.isHidden = false }
			}

		case .firstMealTime:
			if inputedFirstMealTime != nil && lastMealTimeItem == nil {
				// впервые ввели количество приёмов пищи
				setupLastMealTimeItem()
				numberOfMealTimesItem?.respondersNavigationFacade?.barButtonItems.forEach { $0.isHidden = false }
			}

		case .lastMealTime:
			break

		default:
			assertionFailure("?")
		}
	}

	func setupFirstMealTimeItem() {
		guard let numberOfMealTimesItem else {
			assertionFailure("?")
			return
		}

		let firstMealTimeItem = makeFirstMealTimeItem()

		numberOfMealTimesItem.respondersNavigationFacade?.nextResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			firstMealTimeItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		firstMealTimeItem.respondersNavigationFacade?.previousResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			numberOfMealTimesItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		self.firstMealTimeItem = firstMealTimeItem
	}

	func setupLastMealTimeItem() {
		guard let firstMealTimeItem else {
			assertionFailure("?")
			return
		}

		let lastMealTimeItem = makeLastMealTimeItem()

		firstMealTimeItem.respondersNavigationFacade?.nextResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			lastMealTimeItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		lastMealTimeItem.respondersNavigationFacade?.previousResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			firstMealTimeItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		self.lastMealTimeItem = lastMealTimeItem
	}

	func configureCalculatedMealTimeListSection() {
		let calculatedMealTimeList = calculateMealTimeList()

		guard let firstMealTimeDate = calculatedMealTimeList.first,
			  let lastMealTimeDate = calculatedMealTimeList.last
		else {
			calculatedMealTimeListSection = nil
			view?.hideSaveCalculatedMealTimeListButton()
			return
		}

		if calculatedMealTimeList == self.currentCalculatedMealTimeList {
			return
		}

		self.currentCalculatedMealTimeList = calculatedMealTimeList

		let isMealTimeListInSameDay = calendar.isDate(firstMealTimeDate, inSameDayAs: lastMealTimeDate)

		if calculatedMealTimeListSection != nil {
			calculatedMealTimeListSection?.items = assembly
				.calculatedMealTimeListItems(
					for: calculatedMealTimeList,
					isMealTimeListInSameDay: isMealTimeListInSameDay
				)
				.eraseToAnyTableItems()

			calculatedMealTimeListSection?.headerItem = assembly.headerItem(
				firstMealTimeDate: firstMealTimeDate,
				isMealTimeListInSameDay: isMealTimeListInSameDay
			)
		} else {
			// swiftlint:disable:next force_try
			calculatedMealTimeListSection = try! assembly.calculatedMealTimeListSection(
				for: calculatedMealTimeList,
				isMealTimeListInSameDay: isMealTimeListInSameDay
			)
		}

		if calculatedMealTimeList != userDefaultsFacade.calculatedMealTimeList {
			view?.showSaveCalculatedMealTimeListButton()
		} else {
			view?.hideSaveCalculatedMealTimeListButton()
		}
	}

	func calculateMealTimeList() -> [Date] {
		guard let inputedNumberOfMealTimes,
			  let inputedFirstMealTime,
			  let inputedLastMealTime
		else {
			return []
		}

		if inputedNumberOfMealTimes == 0 {
			return []
		}

		if inputedNumberOfMealTimes == 1 {
			assertionFailure("?")
		}

		let diff = calendar.dateComponents(
			[.minute],
			from: inputedFirstMealTime,
			to: inputedLastMealTime
		)
		guard let diffInMinutes = diff.minute else {
			return []
		}

		let periodInMinutes = TimeInterval(diffInMinutes) / TimeInterval(inputedNumberOfMealTimes - 1)

		var mealTimeList = [inputedFirstMealTime]
		for _ in 0..<(inputedNumberOfMealTimes - 1) {
			guard let previousMealTime = mealTimeList.last else {
				continue
			}

			let nextMealTime = previousMealTime.addingTimeInterval(periodInMinutes * 60)
			mealTimeList.append(nextMealTime)
		}

		return mealTimeList
	}

	func convert(mealTime: Date) -> String {
		let dateFormatStyle = Date.FormatStyle().day().month(.wide).hour().minute()
		return mealTime.formatted(dateFormatStyle)
	}

	func convert(mealTimeText: String) -> Date? {
		do {
			return try Date(mealTimeText, strategy: .dateTime)
		} catch {
			assertionFailure(error.localizedDescription)
			return nil
		}
	}

	func shouldChangeDateForFirstMealTimeItem(newDate: Date) -> Bool {
		guard let inputedNumberOfMealTimes,
			  let inputedLastMealTime
		else {
			return true
		}

		notificationFeedbackGenerator.prepare()

		func feedbackWrongDate() {
			notificationFeedbackGenerator.notificationOccurred(.error)
			notificationFeedbackGenerator.prepare()
		}

		if newDate >= inputedLastMealTime {
			feedbackWrongDate()
			return false
		}

		let diff = calendar.dateComponents([.minute], from: newDate, to: inputedLastMealTime)

		guard let diffInMinutes = diff.minute else {
			assertionFailure("?")
			return true
		}

		let shouldChange = diffInMinutes + 1 >= inputedNumberOfMealTimes

		if !shouldChange {
			feedbackWrongDate()
		}

		return shouldChange
	}

	func shouldChangeDateForLastMealTimeItem(newDate: Date) -> Bool {
		guard let inputedNumberOfMealTimes,
			  let inputedFirstMealTime
		else {
			assertionFailure("?")
			return false
		}

		notificationFeedbackGenerator.prepare()

		func feedbackWrongDate() {
			notificationFeedbackGenerator.notificationOccurred(.error)
			notificationFeedbackGenerator.prepare()
		}

		if newDate <= inputedFirstMealTime {
			feedbackWrongDate()
			return false
		}

		let diff = calendar.dateComponents([.minute], from: newDate, to: inputedFirstMealTime)

		guard let diffInMinutes = diff.minute else {
			assertionFailure("?")
			return true
		}

		let shouldChange = (abs(diffInMinutes) + 1) >= inputedNumberOfMealTimes

		if !shouldChange {
			feedbackWrongDate()
		}

		return shouldChange
	}
}
