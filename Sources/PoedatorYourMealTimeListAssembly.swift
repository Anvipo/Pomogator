//
//  PoedatorYourMealTimeListAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 25.09.2021.
//

import Foundation

final class PoedatorYourMealTimeListAssembly: BaseAssembly {}

extension PoedatorYourMealTimeListAssembly {
	func headerItem(
		firstMealTimeDate: Date,
		isMealTimeListInSameDay: Bool
	) -> PlainLabelHeaderItem<PoedatorYourMealTimeListHeaderItemIdentifier> {
		let calculateMealTimeListHeaderItem = PoedatorCalculateMealTimeListAssembly().headerItem(
			firstMealTimeDate: firstMealTimeDate,
			isMealTimeListInSameDay: isMealTimeListInSameDay
		)

		return .init(id: .calculatedMealTimeList, text: calculateMealTimeListHeaderItem.text)
	}

	func calculatedMealTimeListItems(
		for calculatedMealTimeList: [Date],
		isMealTimeListInSameDay: Bool
	) -> [PlainLabelItem<PoedatorYourMealTimeListItemIdentifier>] {
		PoedatorCalculateMealTimeListAssembly().calculatedMealTimeListItems(
			for: calculatedMealTimeList,
			isMealTimeListInSameDay: isMealTimeListInSameDay
		)
		.map { item in
			PlainLabelItem(
				accessoryInfo: item.accessoryInfo,
				backgroundColorHandler: item.backgroundColorHandler,
				id: item.id.yourMealTimeListAnalog,
				text: item.text,
				textAlignment: item.textAlignment,
				textColor: item.textColor,
				textFont: item.textFont,
				tintColor: item.tintColor
			)
		}
	}

	func calculatedMealTimeListSection(
		for calculatedMealTimeList: [Date],
		isMealTimeListInSameDay: Bool
	) throws -> PoedatorYourMealTimeListSection {
		guard let firstMealTimeDate = calculatedMealTimeList.first else {
			let error = PoedatorYourMealTimeListSection.InitError.emptyItems
			assertionFailure(error.localizedDescription)
			throw error
		}

		return try PoedatorYourMealTimeListSection(
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
