//
//  PoedatorSavedMealTimeScheduleAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 25.09.2021.
//

import Foundation

typealias PoedatorMealTimeSchedule = [Date]

final class PoedatorSavedMealTimeScheduleAssembly: BaseAssembly {}

extension PoedatorSavedMealTimeScheduleAssembly {
	func headerItem(
		firstMealTimeDate: Date,
		areAllMealTimeScheduleInSameDay: Bool,
		calendar: Calendar
	) -> PlainLabelHeaderItem<PoedatorSavedMealTimeScheduleHeaderItemIdentifier> {
		let calculateMealTimeScheduleHeaderItem = PoedatorCalculateMealTimeScheduleAssembly().headerItem(
			firstMealTimeDate: firstMealTimeDate,
			areAllMealTimeScheduleInSameDay: areAllMealTimeScheduleInSameDay,
			calendar: calendar
		)

		return .init(id: .savedMealTimeSchedule, text: calculateMealTimeScheduleHeaderItem.text)
	}

	func calculatedMealTimeScheduleItems(
		for calculatedMealTimeSchedule: PoedatorMealTimeSchedule,
		areAllMealTimeScheduleInSameDay: Bool
	) -> [PlainLabelItem<PoedatorSavedMealTimeScheduleItemIdentifier>] {
		PoedatorCalculateMealTimeScheduleAssembly().calculatedMealTimeScheduleItems(
			for: calculatedMealTimeSchedule,
			areAllMealTimeScheduleInSameDay: areAllMealTimeScheduleInSameDay
		)
		.map { oldItem in
			PlainLabelItem(
				accessoryInfo: oldItem.accessoryInfo,
				backgroundColorHandler: oldItem.backgroundColorHandler,
				id: oldItem.id.savedMealTimeScheduleAnalog,
				text: oldItem.text,
				textProperties: oldItem.textProperties,
				tintColor: oldItem.tintColor
			)
		}
	}

	func calculatedMealTimeScheduleSection(
		for calculatedMealTimeSchedule: PoedatorMealTimeSchedule,
		areAllMealTimeScheduleInSameDay: Bool,
		calendar: Calendar
	) throws -> PoedatorSavedMealTimeScheduleSection {
		guard let firstMealTimeDate = calculatedMealTimeSchedule.first else {
			let error = PoedatorSavedMealTimeScheduleSection.InitError.emptyItems
			assertionFailure(error.localizedDescription)
			throw error
		}

		return try PoedatorSavedMealTimeScheduleSection(
			id: .savedMealTimeSchedule,
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
