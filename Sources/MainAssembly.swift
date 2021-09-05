//
//  MainAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit

final class MainAssembly: BaseAssembly {}

extension MainAssembly {
	var emptyPoedatorSection: MainSection {
		// swiftlint:disable:next force_try
		try! MainSection(
			id: .poedator,
			items: [
				emptySectionLabelItem(
					id: MainItemIdentifier.poedator(calculatedMealTimeList: []),
					text: String(localized: "No calculated meal times")
				)
			],
			headerItem: PlainLabelHeaderItem(
				id: MainHeaderItemIdentifier.poedator,
				text: String(localized: "Poedator")
			)
		)
	}

	func poedatorSection(
		for calculatedMealTimeList: [Date],
		isMealTimeListInSameDay: Bool
	) -> MainSection {
		// swiftlint:disable:next force_try
		try! MainSection(
			id: .poedator,
			items: [
				calculatedFirstMealTimeItem(
					for: calculatedMealTimeList,
					isMealTimeListInSameDay: isMealTimeListInSameDay
				)
			],
			headerItem: PlainLabelHeaderItem(
				id: MainHeaderItemIdentifier.poedator,
				text: String(localized: "Poedator")
			)
		)
	}
}

private extension MainAssembly {
	func emptySectionLabelItem<ID: IDType>(
		id: ID,
		text: String
	) -> PlainLabelItem<ID> {
		labelItem(
			id: id,
			text: text,
			textAlignment: .natural,
			textFont: Font.body.uiFont
		)
	}

	func labelItem<ID: IDType>(
		id: ID,
		text: String,
		textAlignment: UIListContentConfiguration.TextProperties.TextAlignment,
		textFont: UIFont
	) -> PlainLabelItem<ID> {
		Pomogator.labelItem(
			id: id,
			text: text,
			accessoryInfo: .accessoryView(UIImageView(image: Image.chevronRight.uiImage)),
			backgroundColorHandler: { cellState in
				if cellState.isHighlighted {
					return Color.brand.highlightedUIColor
				} else {
					return Color.brand.uiColor
				}
			},
			textAlignment: textAlignment,
			textColor: Color.labelOnBrand.uiColor,
			textFont: textFont,
			tintColor: Color.labelOnBrand.uiColor
		)
	}

	func calculatedFirstMealTimeItem(
		for calculatedMealTimeList: [Date],
		isMealTimeListInSameDay: Bool
	) -> PlainLabelItem<MainItemIdentifier> {
		guard let firstMealTime = calculatedMealTimeList.first else {
			fatalError("?")
		}

		return PoedatorCalculateMealTimeListAssembly().calculatedMealTimeListItems(
			for: [firstMealTime],
			isMealTimeListInSameDay: isMealTimeListInSameDay
		)
		.map { item in
			labelItem(
				id: .poedator(calculatedMealTimeList: calculatedMealTimeList),
				text: item.text,
				textAlignment: item.textAlignment,
				textFont: item.textFont
			)
		}
		// swiftlint:disable:next force_unwrapping
		.first!
	}
}
