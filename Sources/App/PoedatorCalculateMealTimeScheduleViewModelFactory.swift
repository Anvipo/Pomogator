//
//  PoedatorCalculateMealTimeScheduleViewModelFactory.swift
//  App
//
//  Created by Anvipo on 25.09.2021.
//

import UIKit

final class PoedatorCalculateMealTimeScheduleViewModelFactory {
	private let dependenciesStorage: DependenciesStorage

	init(dependenciesStorage: DependenciesStorage) {
		self.dependenciesStorage = dependenciesStorage
	}
}

extension PoedatorCalculateMealTimeScheduleViewModelFactory {
	static var currentNumberOfMealTimesFormatStyle: IntegerFormatStyle<UInt> {
		.number
	}

	func calculatedMealTimeScheduleSection(
		for mealTimeSchedule: PoedatorMealTimeSchedule
	) throws -> PoedatorCalculateMealTimeScheduleSection {
		let headerItem = try headerItem(for: mealTimeSchedule)

		return try PoedatorCalculateMealTimeScheduleSection(
			id: .calculatedMealTimeSchedule(headerID: headerItem.id),
			items: calculatedMealTimeScheduleItems(for: mealTimeSchedule),
			headerItem: headerItem
		)
	}
}

extension PoedatorCalculateMealTimeScheduleViewModelFactory {
	func parametersSection(
		currentNumberOfMealTimes: UInt?,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		stringFieldItemDelegate: IStringFieldItemDelegate
	) -> (
		numberOfMealTimesItem: StringFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier>,
		section: PoedatorCalculateMealTimeScheduleSection
	) {
		var numberOfMealTimesItem = Pomogator.stringFieldItem(
			content: StringFieldItem.Content(
				icon: .numberOfMealTimes,
				title: String(localized: "Number of meal times field view title"),
				value: currentNumberOfMealTimes?.formatted(Self.currentNumberOfMealTimesFormatStyle) ?? ""
			),
			delegate: stringFieldItemDelegate,
			id: PoedatorCalculateMealTimeScheduleItemIdentifier.numberOfMealTime
		)

		Pomogator.configureToolbarItems(
			in: &numberOfMealTimesItem,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		return (
			numberOfMealTimesItem,
			try! PoedatorCalculateMealTimeScheduleSection(
				id: .parameters(),
				items: [numberOfMealTimesItem.eraseToAnyTableItem()],
				headerItem: Pomogator.headerItem(
					content: .init(sectionHeaderText: String(localized: "Parameters section header")),
					id: PoedatorCalculateMealTimeScheduleHeaderItemIdentifier.parameters
				)
			)
		)
	}

	func firstMealTimeItem(
		currentFirstMealTime: Date?,
		dateFieldItemDelegate: IDateFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> DateFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier> {
		var item = Pomogator.dateFieldItem(
			content: DateFieldItem.Content(
				icon: .firstMealTime,
				title: String(localized: "First meal time field view title"),
				value: currentFirstMealTime
			),
			calendar: dependenciesStorage.calendar,
			delegate: dateFieldItemDelegate,
			id: PoedatorCalculateMealTimeScheduleItemIdentifier.firstMealTime
		)

		Pomogator.configureToolbarItems(
			in: &item,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		return item
	}

	func lastMealTimeItem(
		currentLastMealTime: Date?,
		dateFieldItemDelegate: IDateFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> DateFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier> {
		var item = Pomogator.dateFieldItem(
			content: DateFieldItem.Content(
				icon: .lastMealTime,
				title: String(localized: "Last meal time field view title"),
				value: currentLastMealTime
			),
			calendar: dependenciesStorage.calendar,
			delegate: dateFieldItemDelegate,
			id: PoedatorCalculateMealTimeScheduleItemIdentifier.lastMealTime
		)

		Pomogator.configureToolbarItems(
			in: &item,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		return item
	}

	func shouldAutoDeleteMealScheduleItem(
		delegate: ISwitchFieldItemDelegate,
		value: Bool
	) -> SwitchFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier> {
		Pomogator.switchFieldItem(
			accessoryButtonFullConfiguration: Pomogator.infoAccessoryFullButtonConfiguration(
				accessibilityLabel: String(localized: "Should autodelete schedule field view accessory button accessibility label")
			),
			content: .init(
				icon: .autoDelete,
				title: String(localized: "Should autodelete schedule field view title"),
				value: value
			),
			delegate: delegate,
			id: PoedatorCalculateMealTimeScheduleItemIdentifier.shouldAutoDeleteSchedule
		)
	}
}

// MARK: - Shared methods

extension PoedatorCalculateMealTimeScheduleViewModelFactory {
	func headerItem(
		for mealTimeSchedule: PoedatorMealTimeSchedule
	) throws -> PlainLabelHeaderItem<PoedatorCalculateMealTimeScheduleHeaderItemIdentifier> {
		guard let firstMealTimeDate = mealTimeSchedule.first else {
			let error = PoedatorCalculateMealTimeScheduleSection.InitError.emptyItems
			assertionFailure(error.localizedDescription)
			throw error
		}

		let calendar = dependenciesStorage.calendar
		let isMealTimeScheduleInSameDay = PoedatorTextManager.isMealTimeScheduleInSameDay(
			calendar: calendar,
			mealTimeSchedule: mealTimeSchedule
		)

		let text: String
		if isMealTimeScheduleInSameDay {
			if calendar.isDateInYesterday(firstMealTimeDate) {
				text = String(localized: "Saved schedule for yesterday section header")
			} else if calendar.isDateInToday(firstMealTimeDate) {
				text = String(localized: "Saved schedule for today section header")
			} else if calendar.isDateInTomorrow(firstMealTimeDate) {
				text = String(localized: "Saved schedule for tomorrow section header")
			} else {
				let dateFormatStyle = Date.FormatStyle().day().month(.wide)
				let dayString = firstMealTimeDate.formatted(dateFormatStyle)
				text = String(localized: "Saved schedule for \(dayString) section header")
			}
		} else {
			text = String(localized: "Saved schedule section header")
		}

		return Pomogator.headerItem(
			content: .init(sectionHeaderText: text),
			id: .calculatedMealTimeSchedule(text: text)
		)
	}

	func calculatedMealTimeScheduleItems(
		for mealTimeSchedule: PoedatorMealTimeSchedule
	) -> [PlainLabelItem<PoedatorCalculateMealTimeScheduleItemIdentifier>] {
		let nextMealTime = mealTimeSchedule.nextMealTime
		let isMealTimeScheduleInSameDay = PoedatorTextManager.isMealTimeScheduleInSameDay(
			calendar: dependenciesStorage.calendar,
			mealTimeSchedule: mealTimeSchedule
		)

		return mealTimeSchedule.map { mealTime in
			Pomogator.labelItem(
				content: .init(
					text: PoedatorTextManager.format(
						mealTime: mealTime,
						addDayAndMonth: !isMealTimeScheduleInSameDay
					),
					customAccessibilityLabel: PoedatorTextManager.format(
						mealTime: mealTime,
						addDayAndMonth: !isMealTimeScheduleInSameDay,
						forVoiceOver: true
					),
					customAccessibilityValue: mealTime == nextMealTime
					? String(localized: "Next meal time accessibility value")
					: nil
				),
				id: .calculatedMealTime(mealTime, isNext: mealTime == nextMealTime),
				style: .grouped,
				backgroundColorHandler: mealTime != nextMealTime
				? nil
				: { _ in ColorStyle.brand.color },
				textAlignment: .center,
				textColorStyle: mealTime != nextMealTime ? nil : .labelOnBrand,
				textFontStyle: .title2
			)
		}
	}
}
