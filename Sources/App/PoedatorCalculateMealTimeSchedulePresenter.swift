//
//  PoedatorCalculateMealTimeSchedulePresenter.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit
import WidgetKit

protocol IPoedatorCalculateMealTimeSchedulePresenterInput: AnyObject {
	func reset()
}

final class PoedatorCalculateMealTimeSchedulePresenter: BasePresenter {
	private let calendar: Calendar
	private let coordinator: PoedatorCoordinator
	private let didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator
	private let didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
	private let poedatorMealTimeScheduleStoreFacade: IPoedatorMealTimeScheduleStoreFacade
	private let selectionFeedbackGenerator: UISelectionFeedbackGenerator
	private let viewModelFactory: PoedatorCalculateMealTimeScheduleViewModelFactory
	private let watchConnectivityFacade: WatchConnectivityFacade
	private let widgetCenter: WidgetCenter

	private var currentNumberOfMealTimes: UInt?
	private var currentFirstMealTime: Date?
	private var currentLastMealTime: Date?
	private var shouldAutoDeleteMealSchedule: Bool

	private var numberOfMealTimesItem: StringFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier>?
	private var firstMealTimeItem: DateFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier>?
	private var lastMealTimeItem: DateFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier>?
	private var shouldAutoDeleteMealScheduleFieldItem: SwitchFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier>?

	private var parametersSection: PoedatorCalculateMealTimeScheduleSection?
	private var calculatedMealTimeScheduleSection: PoedatorCalculateMealTimeScheduleSection?

	private weak var view: PoedatorCalculateMealTimeScheduleVC?

	init(
		calendar: Calendar,
		coordinator: PoedatorCoordinator,
		currentNumberOfMealTimes: UInt?,
		currentFirstMealTime: Date?,
		currentLastMealTime: Date?,
		didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		notificationFeedbackGenerator: UINotificationFeedbackGenerator,
		poedatorMealTimeScheduleStoreFacade: IPoedatorMealTimeScheduleStoreFacade,
		selectionFeedbackGenerator: UISelectionFeedbackGenerator,
		shouldAutoDeleteMealSchedule: Bool,
		viewModelFactory: PoedatorCalculateMealTimeScheduleViewModelFactory,
		watchConnectivityFacade: WatchConnectivityFacade,
		widgetCenter: WidgetCenter
	) {
		self.calendar = calendar
		self.coordinator = coordinator
		self.currentNumberOfMealTimes = currentNumberOfMealTimes
		self.currentFirstMealTime = currentFirstMealTime
		self.currentLastMealTime = currentLastMealTime
		self.didTapFieldViewFeedbackGenerator = didTapFieldViewFeedbackGenerator
		self.didTapBarButtonItemFeedbackGenerator = didTapBarButtonItemFeedbackGenerator
		self.notificationFeedbackGenerator = notificationFeedbackGenerator
		self.poedatorMealTimeScheduleStoreFacade = poedatorMealTimeScheduleStoreFacade
		self.selectionFeedbackGenerator = selectionFeedbackGenerator
		self.shouldAutoDeleteMealSchedule = shouldAutoDeleteMealSchedule
		self.viewModelFactory = viewModelFactory
		self.watchConnectivityFacade = watchConnectivityFacade
		self.widgetCenter = widgetCenter

		/*
		poedatorMealTimeScheduleStoreFacade.inputedFirstMealTimes = []
		poedatorMealTimeScheduleStoreFacade.inputedLastMealTimes = []
		poedatorMealTimeScheduleStoreFacade.inputedNumberOfMealTimes = []
		poedatorMealTimeScheduleStoreFacade.inputedShouldAutoDeleteMealSchedule = []

		poedatorMealTimeScheduleStoreFacade.save(poedatorMealTimeSchedule: [], to: KeyValueStoreFacade.SourceType.allCases)
		 */
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: IRestorable {
	func saveUserActivityForRestore(to userActivity: NSUserActivity) {
		let restoreInfo = PoedatorCalculateMealTimeScheduleRestoreInfo(
			numberOfMealTime: currentNumberOfMealTimes,
			firstMealTime: currentFirstMealTime,
			lastMealTime: currentLastMealTime,
			shouldAutoDeleteMealSchedule: shouldAutoDeleteMealSchedule
		)

		restoreInfo.save(into: userActivity)
	}

	func restore(from userActivity: NSUserActivity) {
		let restoreInfo = PoedatorCalculateMealTimeScheduleRestoreInfo(userActivity: userActivity)

		if restoreInfo.numberOfMealTime == currentNumberOfMealTimes &&
		   restoreInfo.firstMealTime == currentFirstMealTime &&
		   restoreInfo.lastMealTime == currentLastMealTime &&
		   restoreInfo.shouldAutoDeleteMealSchedule == shouldAutoDeleteMealSchedule {
			return
		}

		currentNumberOfMealTimes = restoreInfo.numberOfMealTime
		currentFirstMealTime = restoreInfo.firstMealTime
		currentLastMealTime = restoreInfo.lastMealTime
		shouldAutoDeleteMealSchedule = restoreInfo.shouldAutoDeleteMealSchedule
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: IBaseViewOutput {
	func didTapNCBackButton() {
		coordinator.goToSavedMealTimeScheduleIfNeeded()
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: IBaseTableViewOutput {
	func sectionModel(at sectionIndex: Int) -> PoedatorCalculateMealTimeScheduleSection? {
		if sectionIndex == 0 {
			return parametersSection
		}

		if sectionIndex == 1 {
			return calculatedMealTimeScheduleSection
		}

		fatalError("?")
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: IPoedatorCalculateMealTimeSchedulePresenterInput {
	func reset() {
		currentNumberOfMealTimes = nil
		currentFirstMealTime = nil
		currentLastMealTime = nil
		shouldAutoDeleteMealSchedule = false

		numberOfMealTimesItem = nil
		firstMealTimeItem = nil
		lastMealTimeItem = nil
		shouldAutoDeleteMealScheduleFieldItem = nil

		parametersSection = nil
		calculatedMealTimeScheduleSection = nil

		initialConfigureUI()
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter {
	var isShowingPopover: Bool {
		coordinator.isShowingPopover
	}

	func viewDidLoad() {
		observeScheduleUpdates()

		initialConfigureUI()
	}

	func viewDidAppear() {
		notificationFeedbackGenerator.prepare()
		didTapBarButtonItemFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.prepare()

		updateSaveButtonAccessibilityValue()
	}

	func viewDidDisappear() {
		coordinator.hidePopoverIfNeeded()
	}

	func passToPopover(
		presses: Set<UIPress>,
		event: UIPressesEvent?,
		superImplementation: HandlePressesClosure
	) {
		coordinator.passToPopover(presses: presses, event: event, superImplementation: superImplementation)
	}

	func didTapToFillWithFrequentlyUsedParametersButton() {
		selectionFeedbackGenerator.prepare()

		configureUI(configureScreenKind: .fillWithFrequentlyUsed)

		selectionFeedbackGenerator.selectionChanged()
	}

	func didTapSaveButton() {
		notificationFeedbackGenerator.prepare()

		let calculatedMealTimeSchedule = calculateMealTimeSchedule()

		if calculatedMealTimeSchedule.isOutdated {
			coordinator.showAlert(
				title: String(localized: "Attention"),
				message: String(localized: "Save outdated calculated schedule alert text")
			) { [weak view] in
				view?.accessibilityNotificateAfterOutdatedScheduleAlert()
			}
			notificationFeedbackGenerator.notificationOccurred(.error)
			return
		}

		// TODO: добавить очищение этих данных в разделе настроек
		poedatorMealTimeScheduleStoreFacade.inputedNumberOfMealTimes.append(currentNumberOfMealTimes!)
		poedatorMealTimeScheduleStoreFacade.inputedFirstMealTimes.append(calendar.minutesOfDay(from: currentFirstMealTime!))
		poedatorMealTimeScheduleStoreFacade.inputedLastMealTimes.append(calendar.minutesOfDay(from: currentLastMealTime!))
		poedatorMealTimeScheduleStoreFacade.inputedShouldAutoDeleteMealSchedule.append(shouldAutoDeleteMealSchedule)

		poedatorMealTimeScheduleStoreFacade.save(poedatorMealTimeSchedule: calculatedMealTimeSchedule, to: [.iCloud, .sharedLocal])
		poedatorMealTimeScheduleStoreFacade.areMealTimeScheduleRemindersAdded = false
		poedatorMealTimeScheduleStoreFacade.shouldAutoDeleteMealSchedule = shouldAutoDeleteMealSchedule

		notificationFeedbackGenerator.notificationOccurred(.success)

		widgetCenter.reloadTimelines(ofKind: .poedatorAppWidgetKind)

		watchConnectivityFacade.send(mealTimeSchedule: calculatedMealTimeSchedule)

		coordinator.didUpdateMealTimeSchedule()

		guard let view else {
			assertionFailure("?")
			return
		}

		view.hideSaveCalculatedMealTimeScheduleButton()
		coordinator.goToSavedMealTimeScheduleIfNeeded()
	}

	func didTapAutoDeleteKey() {
		assert(shouldAutoDeleteMealScheduleFieldItem != nil)

		shouldAutoDeleteMealSchedule.toggle()
		shouldAutoDeleteMealScheduleFieldItem?.content.value = shouldAutoDeleteMealSchedule
		if let switchView = shouldAutoDeleteMealScheduleFieldItem?.switchProvider.provider?() {
			switchView.setOn(shouldAutoDeleteMealSchedule, animated: !UIAccessibility.isReduceMotionEnabled)
		} else {
			assertionFailure("?")
		}

		configureUI(configureScreenKind: .localChanches, changingItemID: .shouldAutoDeleteSchedule)
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: IStringFieldItemDelegate {
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

		let currentText = item.content.value
		let possibleString = currentText.replacingCharacters(in: range, with: replacementString)

		if possibleString.isEmpty {
			return true
		}

		let possibleNumber: UInt
		do {
			possibleNumber = try UInt(possibleString, format: type(of: viewModelFactory).currentNumberOfMealTimesFormatStyle)
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

		let currentText = item.content.value

		if itemID != .numberOfMealTime {
			assertionFailure("?")
			return currentText
		}

		if currentText.isEmpty {
			return ""
		}

		let currentNumberOfMealTimes: UInt
		do {
			currentNumberOfMealTimes = try UInt(currentText, format: type(of: viewModelFactory).currentNumberOfMealTimesFormatStyle)
		} catch {
			return ""
		}

		return currentNumberOfMealTimes.formatted(type(of: viewModelFactory).currentNumberOfMealTimesFormatStyle)
	}

	func stringFieldItemDidChangeValue<ID: IDType>(
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

		let newText = item.content.value

		numberOfMealTimesItem?.content.value = newText

		if newText.isEmpty {
			currentNumberOfMealTimes = nil
		} else {
			do {
				currentNumberOfMealTimes = try UInt(newText, format: type(of: viewModelFactory).currentNumberOfMealTimesFormatStyle)
			} catch {
				assertionFailure(error.localizedDescription)
				return
			}
		}

		configureUI(configureScreenKind: .localChanches, changingItemID: itemID)

		guard UIAccessibility.isVoiceOverRunning else {
			return
		}

		let announcementMessage = newText.isEmpty
		? String(localized: "Number of meal times field view new empty accessibility value")
		: String(localized: "Number of meal times field view new nonempty accessibility value - \(newText)")
		UIAccessibility.post(
			notification: .announcement,
			argument: NSAttributedString(
				string: announcementMessage,
				attributes: [.accessibilitySpeechQueueAnnouncement: true]
			)
		)
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: IDateFieldItemDelegate {
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

	func dateFieldItem<ID: IDType>(
		_ item: DateFieldItem<ID>,
		format date: Date
	) -> (text: String, accessibilityText: String) {
		guard let itemID = item.id as? PoedatorCalculateMealTimeScheduleItemIdentifier else {
			assertionFailure("?")
			return ("", "")
		}

		switch itemID {
		case .firstMealTime, .lastMealTime:
			return convert(mealTime: date)

		default:
			assertionFailure("?")
			return ("", "")
		}
	}

	func dateFieldItemDidChangeValue<ID: IDType>(_ item: DateFieldItem<ID>) {
		guard let itemID = item.id as? PoedatorCalculateMealTimeScheduleItemIdentifier else {
			assertionFailure("?")
			return
		}

		let newDate = item.content.value

		switch itemID {
		case .firstMealTime:
			assert(firstMealTimeItem != nil)
			firstMealTimeItem?.content.value = newDate
			currentFirstMealTime = newDate

		case .lastMealTime:
			assert(lastMealTimeItem != nil)
			lastMealTimeItem?.content.value = newDate
			currentLastMealTime = newDate

		default:
			assertionFailure("?")
		}

		configureUI(configureScreenKind: .localChanches, changingItemID: itemID)

		guard UIAccessibility.isVoiceOverRunning else {
			return
		}

		let announcementMessage: String
		if let newDate {
			let (_, newAccessibilityText) = dateFieldItem(item, format: newDate)

			switch itemID {
			case .firstMealTime:
				announcementMessage = String(localized: "First meal time field view new nonempty accessibility value - \(newAccessibilityText)")

			case .lastMealTime:
				announcementMessage = String(localized: "Last meal time field view new nonempty accessibility value - \(newAccessibilityText)")

			default:
				assertionFailure("?")
				return
			}
		} else {
			switch itemID {
			case .firstMealTime:
				announcementMessage = String(localized: "First meal time field view new empty accessibility value")

			case .lastMealTime:
				announcementMessage = String(localized: "Last meal time field view new empty accessibility value")

			default:
				assertionFailure("?")
				return
			}
		}

		UIAccessibility.post(
			notification: .announcement,
			argument: NSAttributedString(
				string: announcementMessage,
				attributes: [.accessibilitySpeechQueueAnnouncement: true]
			)
		)
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: ISwitchFieldItemDelegate {
	func switchFieldItemDidChangeValue<ID: IDType>(_ item: SwitchFieldItem<ID>) {
		guard let itemID = item.id as? PoedatorCalculateMealTimeScheduleItemIdentifier else {
			assertionFailure("?")
			return
		}

		if itemID != .shouldAutoDeleteSchedule {
			assertionFailure("?")
			return
		}

		assert(shouldAutoDeleteMealScheduleFieldItem != nil)
		shouldAutoDeleteMealScheduleFieldItem?.content.value = item.content.value
		shouldAutoDeleteMealSchedule = item.content.value

		configureUI(configureScreenKind: .localChanches, changingItemID: itemID)
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: ITextFieldItemDelegate {
	func textFieldItemDidBeginEditing<ID: Hashable>(_ item: TextFieldItem<ID>) {
		guard item.id is PoedatorCalculateMealTimeScheduleItemIdentifier else {
			assertionFailure("?")
			return
		}

		didTapFieldViewFeedbackGenerator.prepare()
		notificationFeedbackGenerator.prepare()
		didTapBarButtonItemFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.impactOccurred()
	}

	func textFieldItemDidEndEditing<ID: Hashable>(_: TextFieldItem<ID>) {
		updateSaveButtonAccessibilityValue()
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter: IFieldItemDelegate {
	func fieldItem<ID: Hashable>(_ item: FieldItem<ID>, didTapAccessoryButton button: Button) {
		guard let itemID = item.id as? PoedatorCalculateMealTimeScheduleItemIdentifier else {
			assertionFailure("?")
			return
		}

		let text: String
		switch itemID {
		case .shouldAutoDeleteSchedule:
			text = String(localized: "Should autodelete schedule field view info")

		default:
			return
		}

		coordinator.showPopover(
			text: text,
			on: button,
			permittedArrowDirections: [.up, .down]
		)
	}
}

extension PoedatorCalculateMealTimeSchedulePresenter {
	func set(view: PoedatorCalculateMealTimeScheduleVC) {
		self.view = view
	}
}

private extension PoedatorCalculateMealTimeSchedulePresenter {
	enum ConfigureScreenKind {
		case localChanches
		case externallyChanges
		case fillWithFrequentlyUsed
	}

	var parameterFieldItems: [AnyTableViewItem<PoedatorCalculateMealTimeScheduleItemIdentifier>] {
		[
			numberOfMealTimesItem?.eraseToAnyTableItem(),
			firstMealTimeItem?.eraseToAnyTableItem(),
			lastMealTimeItem?.eraseToAnyTableItem(),
			shouldAutoDeleteMealScheduleFieldItem?.eraseToAnyTableItem()
		].compactMap { $0 }
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

		guard let diffInMinutes = calendar.minutes(from: currentFirstMealTime, to: currentLastMealTime) else {
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

		return mealTimeSchedule.compactMap(calendar.dateBySettingZeroSecond(of:))
	}

	func convert(mealTime: Date) -> (text: String, accessibilityText: String) {
		func timeString(addDayAndMonth: Bool) -> String {
			PoedatorTextManager.format(mealTime: mealTime, addDayAndMonth: addDayAndMonth)
		}
		func accessibilityTimeString(addDayAndMonth: Bool) -> String {
			PoedatorTextManager.format(mealTime: mealTime, addDayAndMonth: addDayAndMonth, forVoiceOver: true)
		}

		if calendar.isDateInYesterday(mealTime) {
			return (
				String(localized: "Yesterday in \(timeString(addDayAndMonth: false)) meal time text"),
				String(localized: "Yesterday in \(accessibilityTimeString(addDayAndMonth: false)) meal time text")
			)
		}

		if calendar.isDateInToday(mealTime) {
			return (
				String(localized: "Today in \(timeString(addDayAndMonth: false)) meal time text"),
				String(localized: "Today in \(accessibilityTimeString(addDayAndMonth: false)) meal time text")
			)
		}

		if calendar.isDateInTomorrow(mealTime) {
			return (
				String(localized: "Tomorrow in \(timeString(addDayAndMonth: false)) meal time text"),
				String(localized: "Tomorrow in \(accessibilityTimeString(addDayAndMonth: false)) meal time text")
			)
		}

		return (timeString(addDayAndMonth: true), accessibilityTimeString(addDayAndMonth: true))
	}

	func isValid(numberOfMealTimes: UInt) -> Bool {
		2...9 ~= numberOfMealTimes
	}
}

private extension PoedatorCalculateMealTimeSchedulePresenter {
	func initialConfigureUI() {
		setUpNumberOfMealTimesItem()

		configureUI(configureScreenKind: .localChanches)

		if currentNumberOfMealTimes == nil,
		   poedatorMealTimeScheduleStoreFacade.inputedNumberOfMealTimes.isNotEmpty {
			view?.showFillWithFrequentlyUsedParametersButton()
			selectionFeedbackGenerator.prepare()
		} else {
			view?.hideFillWithFrequentlyUsedParametersButton()
		}
	}

	func configureUI(
		configureScreenKind: ConfigureScreenKind,
		changingItemID: PoedatorCalculateMealTimeScheduleItemIdentifier? = nil
	) {
		didTapBarButtonItemFeedbackGenerator.prepare()

		configureParametersSection(
			configureScreenKind: configureScreenKind,
			changingItemID: changingItemID
		)
		configureCalculatedMealTimeScheduleSection()

		let snapshotData = [
			parametersSection?.snapshotData,
			calculatedMealTimeScheduleSection?.snapshotData
		].compactMap { $0 }

		view?.set(snapshotData: snapshotData)
		updateSaveButtonAccessibilityValue()

		let calculatedMealTimeSchedule = calculateMealTimeSchedule()

		if (calculatedMealTimeSchedule.isNotEmpty &&
			calculatedMealTimeSchedule != poedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.iCloud, .sharedLocal])) ||
			shouldAutoDeleteMealSchedule != poedatorMealTimeScheduleStoreFacade.shouldAutoDeleteMealSchedule {
			view?.showSaveCalculatedMealTimeScheduleButton()
		} else {
			view?.hideSaveCalculatedMealTimeScheduleButton()
		}
	}

	func configureParametersSection(
		configureScreenKind: ConfigureScreenKind,
		changingItemID: PoedatorCalculateMealTimeScheduleItemIdentifier?
	) {
		assert(parametersSection != nil)
		assert(numberOfMealTimesItem != nil)

		defer {
			parametersSection?.items = parameterFieldItems
		}

		let calculatedMealTimeSchedule = calculateMealTimeSchedule()

		guard let changingItemID else {
			if configureScreenKind == .externallyChanges {
				if poedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.iCloud]) != calculatedMealTimeSchedule ||
					poedatorMealTimeScheduleStoreFacade.shouldAutoDeleteMealSchedule != shouldAutoDeleteMealSchedule {
					configureParametersSectionWhenScheduleChangedExternally()
				}
				return
			}

			if configureScreenKind == .fillWithFrequentlyUsed {
				configureParametersSectionWhenScheduleChangedFillWithFrequentlyUsed()
				return
			}

			assert(configureScreenKind == .localChanches, "?")

			if currentNumberOfMealTimes != nil && firstMealTimeItem == nil {
				setUpFirstMealTimeItem()
			}

			if currentFirstMealTime != nil && lastMealTimeItem == nil {
				setUpLastMealTimeItem()
			}

			if lastMealTimeItem != nil {
				setUpShouldAutoDeleteScheduleItem()
			}

			let shouldHide =
			currentNumberOfMealTimes == nil &&
			currentFirstMealTime == nil &&
			currentFirstMealTime == nil

			numberOfMealTimesItem?.toolbarNavigationItemsManager.barNavigationButtonItems.forEach { $0.isHidden = shouldHide }

			return
		}

		switch changingItemID {
		case .numberOfMealTime:
			if currentNumberOfMealTimes != nil && firstMealTimeItem == nil {
				// впервые ввели количество приёмов пищи
				setUpFirstMealTimeItem()
				numberOfMealTimesItem?.toolbarNavigationItemsManager.barNavigationButtonItems.forEach { $0.isHidden = false }
			}

		case .firstMealTime:
			if currentFirstMealTime != nil && lastMealTimeItem == nil {
				// впервые ввели время первого приёма пищи
				setUpLastMealTimeItem()
				numberOfMealTimesItem?.toolbarNavigationItemsManager.barNavigationButtonItems.forEach { $0.isHidden = false }
			}

		case .lastMealTime:
			if shouldAutoDeleteMealScheduleFieldItem == nil {
				setUpShouldAutoDeleteScheduleItem()
			}

		case .shouldAutoDeleteSchedule:
			break

		default:
			assertionFailure("?")
		}
	}

	func configureParametersSectionWhenScheduleChangedExternally() {
		let newSchedule = poedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.iCloud])

		if newSchedule.isEmpty {
			reset()
			return
		}

		if newSchedule.count != (currentNumberOfMealTimes ?? 0) {
			currentNumberOfMealTimes = UInt(newSchedule.count)

			setUpNumberOfMealTimesItem()
		}

		if newSchedule.first != currentFirstMealTime {
			currentFirstMealTime = newSchedule.first

			setUpFirstMealTimeItem()
		}

		if newSchedule.last != currentLastMealTime {
			currentLastMealTime = newSchedule.last

			setUpLastMealTimeItem()
		}

		if poedatorMealTimeScheduleStoreFacade.shouldAutoDeleteMealSchedule != shouldAutoDeleteMealSchedule {
			let newValue = poedatorMealTimeScheduleStoreFacade.shouldAutoDeleteMealSchedule

			shouldAutoDeleteMealScheduleFieldItem?.content.value = newValue
			shouldAutoDeleteMealSchedule = newValue

			if let switchView = shouldAutoDeleteMealScheduleFieldItem?.switchProvider.provider?() {
				switchView.setOn(shouldAutoDeleteMealSchedule, animated: !UIAccessibility.isReduceMotionEnabled)
			} else {
				setUpShouldAutoDeleteScheduleItem()
			}
		}
	}

	func configureParametersSectionWhenScheduleChangedFillWithFrequentlyUsed() {
		let inputedNumberOfMealTimesMode = poedatorMealTimeScheduleStoreFacade.inputedNumberOfMealTimes.mode

		let now = Date.now

		let inputedFirstMealTimesMode = poedatorMealTimeScheduleStoreFacade.inputedFirstMealTimes.mode
		let possibleFirstMealTime = inputedFirstMealTimesMode.flatMap { calendar.date(bySettingMinutesOfDay: $0, of: now) }

		let inputedLastMealTimesMode = poedatorMealTimeScheduleStoreFacade.inputedLastMealTimes.mode
		let possibleLastMealTime = inputedLastMealTimesMode.flatMap { calendar.date(bySettingMinutesOfDay: $0, of: now) }

		let inputedShouldAutoDeleteMealScheduleMode = poedatorMealTimeScheduleStoreFacade.inputedShouldAutoDeleteMealSchedule.mode ?? false

		guard currentNumberOfMealTimes != inputedNumberOfMealTimesMode ||
			  currentFirstMealTime != possibleFirstMealTime ||
			  currentLastMealTime != possibleLastMealTime ||
			  shouldAutoDeleteMealSchedule != inputedShouldAutoDeleteMealScheduleMode
		else { return }

		currentNumberOfMealTimes = inputedNumberOfMealTimesMode
		setUpNumberOfMealTimesItem()

		currentFirstMealTime = possibleFirstMealTime
		setUpFirstMealTimeItem()

		currentLastMealTime = possibleLastMealTime
		setUpLastMealTimeItem()

		shouldAutoDeleteMealSchedule = inputedShouldAutoDeleteMealScheduleMode
		setUpShouldAutoDeleteScheduleItem()
	}

	func setUpNumberOfMealTimesItem() {
		let (numberOfMealTimesItem, parametersSection) = viewModelFactory.parametersSection(
			currentNumberOfMealTimes: currentNumberOfMealTimes,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator,
			stringFieldItemDelegate: self
		)
		self.numberOfMealTimesItem = numberOfMealTimesItem
		self.parametersSection = parametersSection
	}

	func setUpFirstMealTimeItem() {
		guard let numberOfMealTimesItem else {
			assertionFailure("?")
			return
		}

		let firstMealTimeItem = viewModelFactory.firstMealTimeItem(
			currentFirstMealTime: currentFirstMealTime,
			dateFieldItemDelegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		Pomogator.configureNextAndPreviousToolbarItems(
			previousItem: numberOfMealTimesItem,
			previousResponderNavigationBarButtonItemAccessibilityLabel: String(
				localized: "First meal time field view previous toolbar item accessibility label"
			),
			nextItem: firstMealTimeItem,
			nextResponderNavigationBarButtonItemAccessibilityLabel: String(
				localized: "Number of meal times field view next toolbar item accessibility label"
			),
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		self.firstMealTimeItem = firstMealTimeItem
	}

	func setUpLastMealTimeItem() {
		guard let firstMealTimeItem else {
			assertionFailure("?")
			return
		}

		let lastMealTimeItem = viewModelFactory.lastMealTimeItem(
			currentLastMealTime: currentLastMealTime,
			dateFieldItemDelegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		Pomogator.configureNextAndPreviousToolbarItems(
			previousItem: firstMealTimeItem,
			previousResponderNavigationBarButtonItemAccessibilityLabel: String(
				localized: "Last meal time field view previous toolbar item accessibility label"
			),
			nextItem: lastMealTimeItem,
			nextResponderNavigationBarButtonItemAccessibilityLabel: String(
				localized: "First meal time field view next toolbar item accessibility label"
			),
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		self.lastMealTimeItem = lastMealTimeItem
	}

	func setUpShouldAutoDeleteScheduleItem() {
		let shouldAutoDeleteMealScheduleFieldItem = viewModelFactory.shouldAutoDeleteMealScheduleItem(
			delegate: self,
			value: shouldAutoDeleteMealSchedule
		)

		self.shouldAutoDeleteMealScheduleFieldItem = shouldAutoDeleteMealScheduleFieldItem
	}

	func configureCalculatedMealTimeScheduleSection() {
		let calculatedMealTimeSchedule = calculateMealTimeSchedule()

		guard calculatedMealTimeSchedule.isNotEmpty else {
			calculatedMealTimeScheduleSection = nil
			return
		}

		notificationFeedbackGenerator.prepare()

		calculatedMealTimeScheduleSection = try! viewModelFactory.calculatedMealTimeScheduleSection(
			for: calculatedMealTimeSchedule
		)
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

		guard let diffInMinutes = calendar.minutes(from: newDate, to: currentLastMealTime) else {
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

		guard let diffInMinutes = calendar.minutes(from: newDate, to: currentFirstMealTime) else {
			assertionFailure("?")
			return true
		}

		let shouldChange = (abs(diffInMinutes) + 1) >= currentNumberOfMealTimes

		if !shouldChange {
			feedbackWrongDate()
		}

		return shouldChange
	}

	func updateSaveButtonAccessibilityValue() {
		let parameterFieldItems = parameterFieldItems.compactMap(\.fieldItemContainer)
		let buttonAccessibilityValues = parameterFieldItems.compactMap { $0.accessibilityInfoProvider.accessibilityTextProvider?() }

		view?.set(saveButtonAccessibilityValue: buttonAccessibilityValues.joined(separator: ";"))
	}

	func observeScheduleUpdates() {
		observeDidChangeExternallyNotification { [weak self] result in
			guard let self,
				  let notification = result.value,
				  notification.keys.contains(where: { $0 == .poedatorMealTimeScheduleKey || $0 == .shouldAutoDeleteMealScheduleKey }) else {
				return
			}

			self.handleChangedExternallySchedule()

			self.configureUI(configureScreenKind: .externallyChanges)
		}
	}

	func handleChangedExternallySchedule() {
		let poedatorMealTimeSchedule = poedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.iCloud])
		poedatorMealTimeScheduleStoreFacade.save(poedatorMealTimeSchedule: poedatorMealTimeSchedule, to: [.sharedLocal])

		widgetCenter.reloadTimelines(ofKind: .poedatorAppWidgetKind)
	}
}
