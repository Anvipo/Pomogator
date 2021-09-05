//
//  PoedatorCalculateMealTimeListAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 25.09.2021.
//
// swiftlint:disable function_parameter_count

import UIKit

final class PoedatorCalculateMealTimeListAssembly: BaseAssembly {}

extension PoedatorCalculateMealTimeListAssembly {
	func parametersSection(
		inputedNumberOfMealTimes: UInt?,
		stringFieldItemDelegate: StringFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> (
		numberOfMealTimesItem: StringFieldItem<PoedatorCalculateMealTimeListItemIdentifier>,
		section: PoedatorCalculateMealTimeListSection
	) {
		var numberOfMealTimesItem = Pomogator.stringFieldItem(
			id: PoedatorCalculateMealTimeListItemIdentifier.numberOfMealTime,
			content: StringFieldItem.Content(
				icon: Image.numberOfMealTimes.uiImage,
				title: String(localized: "Number of meal times"),
				text: inputedNumberOfMealTimes?.formatted(.number) ?? ""
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
			try! PoedatorCalculateMealTimeListSection(
				id: .parameters,
				items: [numberOfMealTimesItem],
				headerItem: Pomogator.headerItem(text: String(localized: "Parameters"))
			)
		)
	}

	func firstMealTimeItem(
		inputedFirstMealTime: Date?,
		getFirstMealTimeText: @escaping (Date) -> String,
		getFirstMealTime: @escaping (String) -> Date?,
		calendar: Calendar,
		dateFieldItemDelegate: DateFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> DateFieldItem<PoedatorCalculateMealTimeListItemIdentifier> {
		var firstMealTimeItem = Pomogator.dateFieldItem(
			id: PoedatorCalculateMealTimeListItemIdentifier.firstMealTime,
			content: DateFieldItem.Content(
				icon: Image.firstMealTime.uiImage,
				title: String(localized: "First meal time"),
				date: inputedFirstMealTime
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
		inputedLastMealTime: Date?,
		getLastMealTimeText: @escaping (Date) -> String,
		getLastMealTime: @escaping (String) -> Date?,
		calendar: Calendar,
		dateFieldItemDelegate: DateFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> DateFieldItem<PoedatorCalculateMealTimeListItemIdentifier> {
		var lastMealTimeItem = Pomogator.dateFieldItem(
			id: PoedatorCalculateMealTimeListItemIdentifier.lastMealTime,
			content: DateFieldItem.Content(
				icon: Image.lastMealTime.uiImage,
				title: String(localized: "Last meal time"),
				date: inputedLastMealTime
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
		isMealTimeListInSameDay: Bool
	) -> PlainLabelHeaderItem {
		let text: String
		if isMealTimeListInSameDay {
			let dateFormatStyle = Date.FormatStyle().day().month(.wide)
			let dayString = firstMealTimeDate.formatted(dateFormatStyle)
			text = String(localized: "Calculated schedule for \(dayString)")
		} else {
			text = String(localized: "Calculated schedule")
		}

		return Pomogator.headerItem(text: text)
	}

	func calculatedMealTimeListItems(
		for calculatedMealTimeList: [Date],
		isMealTimeListInSameDay: Bool
	) -> [PlainLabelItem<PoedatorCalculateMealTimeListItemIdentifier>] {
		calculatedMealTimeList.map { calculatedMealTime in
			var dateFormatStyle = Date.FormatStyle().hour().minute()
			if !isMealTimeListInSameDay {
				dateFormatStyle = dateFormatStyle.day().month(.wide)
			}

			return Pomogator.labelItem(
				id: .calculatedMealTime(date: calculatedMealTime),
				text: calculatedMealTime.formatted(dateFormatStyle)
			)
		}
	}

	func calculatedMealTimeListSection(
		for calculatedMealTimeList: [Date],
		isMealTimeListInSameDay: Bool
	) throws -> PoedatorCalculateMealTimeListSection {
		guard let firstMealTimeDate = calculatedMealTimeList.first else {
			let error = PoedatorCalculateMealTimeListSection.InitError.emptyItems
			assertionFailure(error.localizedDescription)
			throw error
		}

		return try PoedatorCalculateMealTimeListSection(
			id: .calculatedMealTimeList,
			items: calculatedMealTimeListItems(
				for: calculatedMealTimeList,
				isMealTimeListInSameDay: isMealTimeListInSameDay
			),
			headerItem: headerItem(
				firstMealTimeDate: firstMealTimeDate,
				isMealTimeListInSameDay: isMealTimeListInSameDay
			)
		)
	}
}
