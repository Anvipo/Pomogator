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
				labelItem(
					id: MainItemIdentifier.poedator,
					text: String(localized: "No calculated meal times"),
					textAlignment: .natural,
					textFont: Font.body.uiFont
				)
			],
			headerItem: PlainLabelHeaderItem(text: String(localized: "Poedator"))
		)
	}

	func poedatorSection(
		for calculatedFirstMealTime: Date,
		isMealTimeListInSameDay: Bool
	) -> MainSection {
		// swiftlint:disable:next force_try
		try! MainSection(
			id: .poedator,
			items: [
				calculatedFirstMealTimeItem(
					for: calculatedFirstMealTime,
					isMealTimeListInSameDay: isMealTimeListInSameDay
				)
			],
			headerItem: PlainLabelHeaderItem(text: String(localized: "Poedator"))
		)
	}
}

private extension MainAssembly {
	func labelItem<ID: Hashable>(
		id: ID,
		text: String,
		textAlignment: UIListContentConfiguration.TextProperties.TextAlignment,
		textFont: UIFont
	) -> PlainLabelItem<ID> {
		Pomogator.labelItem(
			id: id,
			text: text,
			accessoryInfo: .accessoryView(UIImageView(image: Image.chevronRight.uiImage)),
			backgroundColor: Color.brand.uiColor,
			textAlignment: textAlignment,
			textColor: Color.labelOnBrand.uiColor,
			textFont: textFont,
			tintColor: Color.labelOnBrand.uiColor
		)
	}

	func calculatedFirstMealTimeItem(
		for calculatedMealTimeList: Date,
		isMealTimeListInSameDay: Bool
	) -> PlainLabelItem<MainItemIdentifier> {
		PoedatorCalculateMealTimeListAssembly().calculatedMealTimeListItems(
			for: [calculatedMealTimeList],
			isMealTimeListInSameDay: isMealTimeListInSameDay
		)
		.map { item in
			labelItem(
				id: item.id.mainAnalog,
				text: item.text,
				textAlignment: item.textAlignment,
				textFont: item.textFont
			)
		}
		// swiftlint:disable:next force_unwrapping
		.first!
	}
}
