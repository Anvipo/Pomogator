//
//  PoedatorCalculateMealTimeSchedulePresenter.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//
// swiftlint:disable file_length

import UIKit

final class PoedatorCalculateMealTimeSchedulePresenter: BasePresenter {
	private let assembly: PoedatorCalculateMealTimeScheduleAssembly
	private let calendar: Calendar
	private let coordinator: PoedatorCoordinator
	private let didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator
	private let didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
	private let userDefaultsFacade: PoedatorUserDefaultsFacade

	private var currentNumberOfMealTimes: UInt?
	private var currentFirstMealTime: Date?
	private var currentLastMealTime: Date?
	private var currentCalculatedMealTimeSchedule: PoedatorMealTimeSchedule

	private var numberOfMealTimesItem: StringFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier>?
	private var firstMealTimeItem: DateFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier>?
	private var lastMealTimeItem: DateFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier>?

	private var parametersSection: PoedatorCalculateMealTimeScheduleSection?
	private var calculatedMealTimeScheduleSection: PoedatorCalculateMealTimeScheduleSection?

	private weak var view: PoedatorCalculateMealTimeScheduleVC?

	init(
		assembly: PoedatorCalculateMealTimeScheduleAssembly,
		calendar: Calendar,
		coordinator: PoedatorCoordinator,
		didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		notificationFeedbackGenerator: UINotificationFeedbackGenerator,
		currentNumberOfMealTimes: UInt?,
		currentFirstMealTime: Date?,
		currentLastMealTime: Date?,
		userDefaultsFacade: PoedatorUserDefaultsFacade
	) {
		self.assembly = assembly
		self.calendar = calendar
		self.coordinator = coordinator
		self.didTapFieldViewFeedbackGenerator = didTapFieldViewFeedbackGenerator
		self.didTapBarButtonItemFeedbackGenerator = didTapBarButtonItemFeedbackGenerator
		self.notificationFeedbackGenerator = notificationFeedbackGenerator
		self.currentNumberOfMealTimes = currentNumberOfMealTimes
		self.currentFirstMealTime = currentFirstMealTime
		self.currentLastMealTime = currentLastMealTime
		self.userDefaultsFacade = userDefaultsFacade

		currentCalculatedMealTimeSchedule = []

		super.init(baseCoordinator: coordinator)
	}

	override func baseViewDidAppear() {
		super.baseViewDidAppear()
		notificationFeedbackGenerator.prepare()
		didTapBarButtonItemFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.prepare()
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: IRestorable {
	func saveUserActivityForRestore(to userActivity: NSUserActivity) {
		let restoreInfo = PoedatorCalculateMealTimeScheduleRestoreInfo(
			numberOfMealTime: currentNumberOfMealTimes,
			firstMealTime: currentFirstMealTime,
			lastMealTime: currentLastMealTime
		)

		restoreInfo.save(into: userActivity)
	}

	func restore(from userActivity: NSUserActivity) {
		let restoreInfo = PoedatorCalculateMealTimeScheduleRestoreInfo(userActivity: userActivity)

		currentNumberOfMealTimes = restoreInfo.numberOfMealTime
		currentFirstMealTime = restoreInfo.firstMealTime
		currentLastMealTime = restoreInfo.lastMealTime
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter {
	func viewDidLoad() {
		let (numberOfMealTimesItem, parametersSection) = assembly.parametersSection(
			currentNumberOfMealTimes: currentNumberOfMealTimes,
			stringFieldItemDelegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)
		self.numberOfMealTimesItem = numberOfMealTimesItem
		self.parametersSection = parametersSection

		configureUI(changingItemID: nil)
	}

	func sectionModel(at sectionIndex: Int) -> PoedatorCalculateMealTimeScheduleSection? {
		switch sectionIndex {
		case 0:
			return parametersSection

		case 1:
			return calculatedMealTimeScheduleSection

		default:
			assertionFailure("?")
			return nil
		}
	}

	func itemModel(
		by id: PoedatorCalculateMealTimeScheduleItemIdentifier,
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

	func didTapSaveButton() {
		userDefaultsFacade.mealTimeSchedule = currentCalculatedMealTimeSchedule
		userDefaultsFacade.areMealTimeScheduleRemindersAdded = false

		notificationFeedbackGenerator.notificationOccurred(.success)

		coordinator.hideCalculateMealTimeSchedule()
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: StringFieldItemDelegate {
	func stringFieldItem<ID: IDType>(
		_ item: StringFieldItem<ID>,
		shouldChangeCharactersIn range: Range<String.Index>,
		replacementString: String
	) -> Bool {
		guard let itemID = item.id as? PoedatorCalculateMealTimeScheduleItemIdentifier else {
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
			possibleNumber = try UInt(possibleString, format: assembly.currentNumberOfMealTimesFormatStyle)
		} catch {
			return false
		}

		let shouldChange = isValid(numberOfMealTimes: possibleNumber)

		if !shouldChange {
			feedbackWrongText()
		}

		return shouldChange
	}

	func stringFieldItemFormattedString<ID: IDType>(
		_ item: StringFieldItem<ID>
	) -> String {
		guard let itemID = item.id as? PoedatorCalculateMealTimeScheduleItemIdentifier else {
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

		let currentNumberOfMealTimes: UInt
		do {
			currentNumberOfMealTimes = try UInt(currentText, format: assembly.currentNumberOfMealTimesFormatStyle)
		} catch {
			return ""
		}

		return currentNumberOfMealTimes.formatted(assembly.currentNumberOfMealTimesFormatStyle)
	}

	func stringFieldItemDidChangeString<ID: IDType>(
		_ item: StringFieldItem<ID>
	) {
		guard let itemID = item.id as? PoedatorCalculateMealTimeScheduleItemIdentifier else {
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
			currentNumberOfMealTimes = nil
			currentCalculatedMealTimeSchedule = []
		} else {
			do {
				currentNumberOfMealTimes = try UInt(newText, format: assembly.currentNumberOfMealTimesFormatStyle)
			} catch {
				assertionFailure(error.localizedDescription)
				return
			}
		}

		didTapBarButtonItemFeedbackGenerator.prepare()

		configureUI(changingItemID: itemID)
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: DateFieldItemDelegate {
	func dateFieldItem<ID: IDType>(
		_ item: DateFieldItem<ID>,
		shouldChangeTo newDate: Date
	) -> Bool {
		guard let itemID = item.id as? PoedatorCalculateMealTimeScheduleItemIdentifier else {
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

	func dateFieldItemDidChangeDate<ID: IDType>(_ item: DateFieldItem<ID>) {
		guard let itemID = item.id as? PoedatorCalculateMealTimeScheduleItemIdentifier else {
			assertionFailure("?")
			return
		}

		let newDate = item.content.date

		switch itemID {
		case .firstMealTime:
			assert(firstMealTimeItem != nil)
			firstMealTimeItem?.content.date = newDate
			currentFirstMealTime = newDate

		case .lastMealTime:
			assert(lastMealTimeItem != nil)
			lastMealTimeItem?.content.date = newDate
			currentLastMealTime = newDate

		default:
			assertionFailure("?")
		}

		didTapBarButtonItemFeedbackGenerator.prepare()

		configureUI(changingItemID: itemID)
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: FieldItemDelegate {
	func fieldItemDidBeginEditing<ID: IDType>(_ item: FieldItem<ID>) {
		guard item.id is PoedatorCalculateMealTimeScheduleItemIdentifier else {
			assertionFailure("?")
			return
		}

		notificationFeedbackGenerator.prepare()
		didTapBarButtonItemFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.impactOccurred()
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter {
	func set(view: PoedatorCalculateMealTimeScheduleVC) {
		self.view = view
	}
}

private extension PoedatorCalculateMealTimeSchedulePresenter {
	func configureUI(changingItemID: PoedatorCalculateMealTimeScheduleItemIdentifier?) {
		configureParametersSection(changingItemID: changingItemID)
		configureCalculatedMealTimeScheduleSection()

		let snapshotData = [
			parametersSection?.snapshotData,
			calculatedMealTimeScheduleSection?.snapshotData
		].compactMap { $0 }

		view?.set(snapshotData: snapshotData)

		if !currentCalculatedMealTimeSchedule.isEmpty &&
			currentCalculatedMealTimeSchedule != userDefaultsFacade.mealTimeSchedule {
			view?.showSaveCalculatedMealTimeScheduleButton()
		} else {
			view?.hideSaveCalculatedMealTimeScheduleButton()
		}
	}

	func makeFirstMealTimeItem() -> DateFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier> {
		assembly.firstMealTimeItem(
			currentFirstMealTime: currentFirstMealTime,
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

	func makeLastMealTimeItem() -> DateFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier> {
		assembly.lastMealTimeItem(
			currentLastMealTime: currentLastMealTime,
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

	func configureParametersSection(changingItemID: PoedatorCalculateMealTimeScheduleItemIdentifier?) {
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
			if currentNumberOfMealTimes != nil && firstMealTimeItem == nil {
				setupFirstMealTimeItem()
			}

			if currentFirstMealTime != nil && lastMealTimeItem == nil {
				setupLastMealTimeItem()
			}

			let shouldHide =
			currentNumberOfMealTimes == nil &&
			currentFirstMealTime == nil &&
			currentFirstMealTime == nil

			numberOfMealTimesItem?.respondersNavigationFacade?.barButtonItems.forEach { $0.isHidden = shouldHide }

			return
		}

		switch changingItemID {
		case .numberOfMealTime:
			if currentNumberOfMealTimes != nil && firstMealTimeItem == nil {
				// впервые ввели количество приёмов пищи
				setupFirstMealTimeItem()
				numberOfMealTimesItem?.respondersNavigationFacade?.barButtonItems.forEach { $0.isHidden = false }
			}

		case .firstMealTime:
			if currentFirstMealTime != nil && lastMealTimeItem == nil {
				// впервые ввели время первого приёма пищи
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

	func configureCalculatedMealTimeScheduleSection() {
		let calculatedMealTimeSchedule = calculateMealTimeSchedule()

		guard let firstMealTimeDate = calculatedMealTimeSchedule.first,
			  let lastMealTimeDate = calculatedMealTimeSchedule.last
		else {
			calculatedMealTimeScheduleSection = nil
			view?.hideSaveCalculatedMealTimeScheduleButton()
			return
		}

		if calculatedMealTimeSchedule == currentCalculatedMealTimeSchedule {
			return
		}

		notificationFeedbackGenerator.prepare()

		currentCalculatedMealTimeSchedule = calculatedMealTimeSchedule

		let isMealTimeScheduleInSameDay = calendar.isDate(firstMealTimeDate, inSameDayAs: lastMealTimeDate)

		if calculatedMealTimeScheduleSection != nil {
			calculatedMealTimeScheduleSection?.items = assembly
				.calculatedMealTimeScheduleItems(
					for: calculatedMealTimeSchedule,
					isMealTimeScheduleInSameDay: isMealTimeScheduleInSameDay
				)
				.eraseToAnyTableItems()

			calculatedMealTimeScheduleSection?.headerItem = assembly
				.headerItem(
					firstMealTimeDate: firstMealTimeDate,
					isMealTimeScheduleInSameDay: isMealTimeScheduleInSameDay
				)
		} else {
			// swiftlint:disable:next force_try
			calculatedMealTimeScheduleSection = try! assembly.calculatedMealTimeScheduleSection(
				for: calculatedMealTimeSchedule,
				isMealTimeScheduleInSameDay: isMealTimeScheduleInSameDay
			)
		}
	}

	func calculateMealTimeSchedule() -> PoedatorMealTimeSchedule {
		guard let currentNumberOfMealTimes,
			  let currentFirstMealTime,
			  let currentLastMealTime
		else {
			return []
		}

		if !isValid(numberOfMealTimes: currentNumberOfMealTimes) {
			return []
		}

		let diff = calendar.dateComponents(
			[.minute],
			from: currentFirstMealTime,
			to: currentLastMealTime
		)
		guard let diffInMinutes = diff.minute else {
			return []
		}

		let periodInMinutes = TimeInterval(diffInMinutes) / TimeInterval(currentNumberOfMealTimes - 1)

		var mealTimeSchedule = [currentFirstMealTime]
		for _ in 0..<(currentNumberOfMealTimes - 1) {
			guard let previousMealTime = mealTimeSchedule.last else {
				continue
			}

			let nextMealTime = previousMealTime.addingTimeInterval(periodInMinutes * 60)
			mealTimeSchedule.append(nextMealTime)
		}

		return mealTimeSchedule
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

	func isValid(numberOfMealTimes: UInt) -> Bool {
		2...9 ~= numberOfMealTimes
	}

	func shouldChangeDateForFirstMealTimeItem(newDate: Date) -> Bool {
		guard let currentNumberOfMealTimes,
			  let currentLastMealTime
		else {
			return true
		}

		notificationFeedbackGenerator.prepare()

		func feedbackWrongDate() {
			notificationFeedbackGenerator.notificationOccurred(.error)
			notificationFeedbackGenerator.prepare()
		}

		if newDate >= currentLastMealTime {
			feedbackWrongDate()
			return false
		}

		let diff = calendar.dateComponents([.minute], from: newDate, to: currentLastMealTime)

		guard let diffInMinutes = diff.minute else {
			assertionFailure("?")
			return true
		}

		let shouldChange = diffInMinutes + 1 >= currentNumberOfMealTimes

		if !shouldChange {
			feedbackWrongDate()
		}

		return shouldChange
	}

	func shouldChangeDateForLastMealTimeItem(newDate: Date) -> Bool {
		guard let currentNumberOfMealTimes,
			  let currentFirstMealTime
		else {
			assertionFailure("?")
			return false
		}

		notificationFeedbackGenerator.prepare()

		func feedbackWrongDate() {
			notificationFeedbackGenerator.notificationOccurred(.error)
			notificationFeedbackGenerator.prepare()
		}

		if newDate <= currentFirstMealTime {
			feedbackWrongDate()
			return false
		}

		let diff = calendar.dateComponents([.minute], from: newDate, to: currentFirstMealTime)

		guard let diffInMinutes = diff.minute else {
			assertionFailure("?")
			return true
		}

		let shouldChange = (abs(diffInMinutes) + 1) >= currentNumberOfMealTimes

		if !shouldChange {
			feedbackWrongDate()
		}

		return shouldChange
	}
}
