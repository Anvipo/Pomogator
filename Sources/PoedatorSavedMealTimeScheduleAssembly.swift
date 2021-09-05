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
		isMealTimeScheduleInSameDay: Bool
	) -> PlainLabelHeaderItem<PoedatorSavedMealTimeScheduleHeaderItemIdentifier> {
		let calculateMealTimeScheduleHeaderItem = PoedatorCalculateMealTimeScheduleAssembly().headerItem(
			firstMealTimeDate: firstMealTimeDate,
			isMealTimeScheduleInSameDay: isMealTimeScheduleInSameDay
		)

		return .init(id: .savedMealTimeSchedule, text: calculateMealTimeScheduleHeaderItem.text)
	}

	func calculatedMealTimeScheduleItems(
		for calculatedMealTimeSchedule: PoedatorMealTimeSchedule,
		isMealTimeScheduleInSameDay: Bool
	) -> [PlainLabelItem<PoedatorSavedMealTimeScheduleItemIdentifier>] {
		PoedatorCalculateMealTimeScheduleAssembly().calculatedMealTimeScheduleItems(
			for: calculatedMealTimeSchedule,
			isMealTimeScheduleInSameDay: isMealTimeScheduleInSameDay
		)
		.map { item in
			PlainLabelItem(
				accessoryInfo: item.accessoryInfo,
				backgroundColorHandler: item.backgroundColorHandler,
				id: item.id.savedMealTimeScheduleAnalog,
				text: item.text,
				textAlignment: item.textAlignment,
				textColor: item.textColor,
				textFont: item.textFont,
				tintColor: item.tintColor
			)
		}
	}

	func calculatedMealTimeScheduleSection(
		for calculatedMealTimeSchedule: PoedatorMealTimeSchedule,
		isMealTimeScheduleInSameDay: Bool
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
				isMealTimeScheduleInSameDay: isMealTimeScheduleInSameDay
			),
			headerItem: headerItem(
				firstMealTimeDate: firstMealTimeDate,
				isMealTimeScheduleInSameDay: isMealTimeScheduleInSameDay
			)
		)
	}
}
