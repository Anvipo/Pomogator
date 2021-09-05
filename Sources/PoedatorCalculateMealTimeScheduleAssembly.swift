//
//  PoedatorCalculateMealTimeScheduleAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 25.09.2021.
//
// swiftlint:disable function_parameter_count

import UIKit

final class PoedatorCalculateMealTimeScheduleAssembly: BaseAssembly {}

extension PoedatorCalculateMealTimeScheduleAssembly {
	var currentNumberOfMealTimesFormatStyle: IntegerFormatStyle<UInt> {
		.number
	}

	func parametersSection(
		currentNumberOfMealTimes: UInt?,
		stringFieldItemDelegate: StringFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> (
		numberOfMealTimesItem: StringFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier>,
		section: PoedatorCalculateMealTimeScheduleSection
	) {
		var numberOfMealTimesItem = Pomogator.stringFieldItem(
			id: PoedatorCalculateMealTimeScheduleItemIdentifier.numberOfMealTime,
			content: StringFieldItem.Content(
				icon: Image.numberOfMealTimes.uiImage,
				title: String(localized: "Number of meal times field view title"),
				text: currentNumberOfMealTimes?.formatted(currentNumberOfMealTimesFormatStyle) ?? ""
			),
			textKeyboardType: .numberPad,
			delegate: stringFieldItemDelegate
		)

		Pomogator.configureToolbarItems(
			in: &numberOfMealTimesItem,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		return (
			numberOfMealTimesItem,
			// swiftlint:disable:next force_try
			try! PoedatorCalculateMealTimeScheduleSection(
				id: .parameters,
				items: [numberOfMealTimesItem],
				headerItem: Pomogator.headerItem(
					id: PoedatorCalculateMealTimeScheduleHeaderItemIdentifier.parameters,
					text: String(localized: "Parameters section header")
				)
			)
		)
	}

	func firstMealTimeItem(
		currentFirstMealTime: Date?,
		getFirstMealTimeText: @escaping (Date) -> String,
		getFirstMealTime: @escaping (String) -> Date?,
		calendar: Calendar,
		dateFieldItemDelegate: DateFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> DateFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier> {
		var firstMealTimeItem = Pomogator.dateFieldItem(
			id: PoedatorCalculateMealTimeScheduleItemIdentifier.firstMealTime,
			content: DateFieldItem.Content(
				icon: Image.firstMealTime.uiImage,
				title: String(localized: "First meal time field view title"),
				date: currentFirstMealTime
			),
			calendar: calendar,
			delegate: dateFieldItemDelegate,
			getDateText: getFirstMealTimeText,
			getDate: getFirstMealTime
		)

		Pomogator.configureToolbarItems(
			in: &firstMealTimeItem,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		return firstMealTimeItem
	}

	func lastMealTimeItem(
		currentLastMealTime: Date?,
		getLastMealTimeText: @escaping (Date) -> String,
		getLastMealTime: @escaping (String) -> Date?,
		calendar: Calendar,
		dateFieldItemDelegate: DateFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> DateFieldItem<PoedatorCalculateMealTimeScheduleItemIdentifier> {
		var lastMealTimeItem = Pomogator.dateFieldItem(
			id: PoedatorCalculateMealTimeScheduleItemIdentifier.lastMealTime,
			content: DateFieldItem.Content(
				icon: Image.lastMealTime.uiImage,
				title: String(localized: "Last meal time field view title"),
				date: currentLastMealTime
			),
			calendar: calendar,
			delegate: dateFieldItemDelegate,
			getDateText: getLastMealTimeText,
			getDate: getLastMealTime
		)

		Pomogator.configureToolbarItems(
			in: &lastMealTimeItem,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		return lastMealTimeItem
	}

	func headerItem(
		firstMealTimeDate: Date,
		areAllMealTimeScheduleInSameDay: Bool,
		calendar: Calendar
	) -> PlainLabelHeaderItem<PoedatorCalculateMealTimeScheduleHeaderItemIdentifier> {
		let text: String
		if areAllMealTimeScheduleInSameDay {
			if calendar.isDateInYesterday(firstMealTimeDate) {
				text = String(localized: "Calculated schedule for yesterday section header")
			} else if calendar.isDateInToday(firstMealTimeDate) {
				text = String(localized: "Calculated schedule for today section header")
			} else if calendar.isDateInTomorrow(firstMealTimeDate) {
				text = String(localized: "Calculated schedule for tomorrow section header")
			} else {
				let dateFormatStyle = Date.FormatStyle().day().month(.wide)
				let dayString = firstMealTimeDate.formatted(dateFormatStyle)
				text = String(localized: "Calculated schedule for \(dayString) section header")
			}
		} else {
			text = String(localized: "Calculated schedule section header")
		}

		return Pomogator.headerItem(
			id: .calculatedMealTimeSchedule,
			text: text
		)
	}

	func calculatedMealTimeScheduleItems(
		for calculatedMealTimeSchedule: PoedatorMealTimeSchedule,
		areAllMealTimeScheduleInSameDay: Bool
	) -> [PlainLabelItem<PoedatorCalculateMealTimeScheduleItemIdentifier>] {
		calculatedMealTimeSchedule.map { calculatedMealTime in
			var dateFormatStyle = Date.FormatStyle().hour().minute()
			if !areAllMealTimeScheduleInSameDay {
				dateFormatStyle = dateFormatStyle.day().month(.wide)
			}

			return Pomogator.labelItem(
				id: .calculatedMealTime(id: UUID()),
				text: calculatedMealTime.formatted(dateFormatStyle),
				textAlignment: .center,
				textFont: Font.title3.uiFont
			)
		}
	}

	func calculatedMealTimeScheduleSection(
		for calculatedMealTimeSchedule: PoedatorMealTimeSchedule,
		areAllMealTimeScheduleInSameDay: Bool,
		calendar: Calendar
	) throws -> PoedatorCalculateMealTimeScheduleSection {
		guard let firstMealTimeDate = calculatedMealTimeSchedule.first else {
			let error = PoedatorCalculateMealTimeScheduleSection.InitError.emptyItems
			assertionFailure(error.localizedDescription)
			throw error
		}

		return try PoedatorCalculateMealTimeScheduleSection(
			id: .calculatedMealTimeSchedule,
			items: calculatedMealTimeScheduleItems(
				for: calculatedMealTimeSchedule,
				areAllMealTimeScheduleInSameDay: areAllMealTimeScheduleInSameDay
			),
			headerItem: headerItem(
				firstMealTimeDate: firstMealTimeDate,
				areAllMealTimeScheduleInSameDay: areAllMealTimeScheduleInSameDay,
				calendar: calendar
			)
		)
	}
}
