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
		poedatorSection(
			items: [
				emptySectionLabelItem(
					id: MainItemIdentifier.poedator(nextMealTime: nil),
					text: String(localized: "No saved meal time schedule text 1")
				)
			]
		)
	}

	var emptyPoedatorForTodaySection: MainSection {
		poedatorSection(
			items: [
				emptySectionLabelItem(
					id: MainItemIdentifier.poedator(nextMealTime: nil),
					text: String(localized: "No saved meal time schedule text")
				)
			]
		)
	}

	func poedatorSection(
		for savedMealTimeSchedule: PoedatorMealTimeSchedule,
		isMealTimeScheduleInSameDay: Bool
	) -> MainSection {
		let item: any ReusableTableViewItem
		if let nextMealTime = savedMealTimeSchedule.nearest(from: .now) {
			item = poedatorNextMealTimeItem(
				for: nextMealTime,
				isMealTimeScheduleInSameDay: isMealTimeScheduleInSameDay
			)
		} else {
			item = emptySectionLabelItem(
				id: MainItemIdentifier.poedator(nextMealTime: nil),
				text: String(localized: "No upcoming meal time schedule text")
			)
		}

		return poedatorSection(items: [item])
	}
}

private extension MainAssembly {
	func poedatorSection(items: [any ReusableTableViewItem]) -> MainSection {
		// swiftlint:disable:next force_try
		try! MainSection(
			id: .poedator,
			items: items,
			headerItem: PlainLabelHeaderItem(
				id: MainHeaderItemIdentifier.poedator,
				text: String(localized: "Poedator")
			)
		)
	}

	func poedatorNextMealTimeItem(
		for nextMealTime: Date,
		isMealTimeScheduleInSameDay: Bool
	) -> PlainLabelItem<MainItemIdentifier> {
		var dateFormatStyle = Date.FormatStyle().hour().minute()
		if !isMealTimeScheduleInSameDay {
			dateFormatStyle = dateFormatStyle.day().month(.wide)
		}

		return labelItem(
			id: .poedator(nextMealTime: nextMealTime),
			text: nextMealTime.formatted(dateFormatStyle),
			textAlignment: .center,
			textFont: Font.title2.uiFont
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
}
