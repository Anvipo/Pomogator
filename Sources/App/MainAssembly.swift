//
//  MainAssembly.swift
//  App
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit

final class MainAssembly {
	private let dependenciesStorage: DependenciesStorage

	init(dependenciesStorage: DependenciesStorage) {
		self.dependenciesStorage = dependenciesStorage
	}
}

// MARK: - Poedator

extension MainAssembly {
	func poedatorSection(
		for mealTimeSchedule: PoedatorMealTimeSchedule,
		pointerInteractionDelegate: UIPointerInteractionDelegate
	) -> MainSection {
		let calendar = dependenciesStorage.calendar
		let text = PoedatorTextManager.text(for: mealTimeSchedule, calendar: calendar)
		let isMealTimeScheduleInSameDay = PoedatorTextManager.isMealTimeScheduleInSameDay(
			calendar: calendar,
			mealTimeSchedule: mealTimeSchedule
		)
		let isMealTimeScheduleInToday = PoedatorTextManager.isMealTimeScheduleInToday(
			calendar: calendar,
			mealTimeSchedule: mealTimeSchedule
		)

		let item: any IReusableTableViewItem
		let footerItem: (any IReusableTableViewHeaderFooterItem)?
		if let nextMealTime = mealTimeSchedule.nextMealTime {
			let footerText = String(localized: "Poedator main footer text")
			let accessibilityText = PoedatorTextManager.text(
				for: mealTimeSchedule,
				calendar: calendar,
				forVoiceOver: true
			)

			item = nonEmptySectionLabelItem(
				content: .init(
					text: text,
					customAccessibilityLabel: footerText,
					customAccessibilityValue: accessibilityText
				),
				id: MainItemIdentifier.poedator(
					nextMealTime: nextMealTime,
					isVoiceOverRunning: UIAccessibility.isVoiceOverRunning
				),
				pointerInteractionDelegate: pointerInteractionDelegate
			)
			footerItem = Pomogator.footerItem(
				id: MainHeaderItemIdentifier.poedator,
				text: footerText
			)
		} else if mealTimeSchedule.isEmpty {
			item = emptySectionLabelItem(
				content: .init(text: text),
				id: MainItemIdentifier.noPoedatorSchedule,
				pointerInteractionDelegate: pointerInteractionDelegate
			)
			footerItem = nil
		} else if isMealTimeScheduleInSameDay && isMealTimeScheduleInToday {
			item = emptySectionLabelItem(
				content: .init(text: text),
				id: MainItemIdentifier.noPoedatorScheduleForToday,
				pointerInteractionDelegate: pointerInteractionDelegate
			)
			footerItem = nil
		} else {
			item = emptySectionLabelItem(
				content: .init(text: text),
				id: MainItemIdentifier.noPoedatorActualSchedule,
				pointerInteractionDelegate: pointerInteractionDelegate
			)
			footerItem = nil
		}

		return try! MainSection(
			id: .poedator,
			items: [item],
			headerItem: Pomogator.headerItem(
				content: .init(sectionHeaderText: String(localized: "Poedator main header text")),
				id: MainHeaderItemIdentifier.poedator
			),
			footerItem: UIAccessibility.isVoiceOverRunning ? nil : footerItem
		)
	}
}

// MARK: - Common

private extension MainAssembly {
	func emptySectionLabelItem<ID: IDType>(
		content: PlainLabelItem<ID>.Content,
		id: ID,
		pointerInteractionDelegate: UIPointerInteractionDelegate
	) -> PlainLabelItem<ID> {
		let textFontStyle = FontStyle.title2

		return labelItem(
			accessoryInfo: .accessoryImage(
				Image.chevronTrailing.uiImage.withConfiguration(textFontStyle.symbolConfiguration),
				adjustsImageSizeForAccessibilityContentSizeCategory: true
			),
			content: content,
			id: id,
			pointerInteractionDelegate: pointerInteractionDelegate,
			textAlignment: .natural,
			textFontStyle: textFontStyle
		)
	}

	func nonEmptySectionLabelItem<ID: IDType>(
		content: PlainLabelItem<ID>.Content,
		id: ID,
		pointerInteractionDelegate: UIPointerInteractionDelegate
	) -> PlainLabelItem<ID> {
		let textFontStyle = FontStyle.title2

		return labelItem(
			accessoryInfo: .accessoryImage(
				Image.chevronTrailing.uiImage.withConfiguration(textFontStyle.symbolConfiguration),
				adjustsImageSizeForAccessibilityContentSizeCategory: true
			),
			content: content,
			id: id,
			pointerInteractionDelegate: pointerInteractionDelegate,
			textAlignment: .center,
			textFontStyle: textFontStyle
		)
	}

	func labelItem<ID: IDType>(
		accessoryInfo: TableViewCellAccessoryInfo?,
		content: PlainLabelItem<ID>.Content,
		id: ID,
		pointerInteractionDelegate: UIPointerInteractionDelegate,
		textAlignment: UIListContentConfiguration.TextProperties.TextAlignment,
		textFontStyle: FontStyle
	) -> PlainLabelItem<ID> {
		Pomogator.labelItem(
			content: content,
			id: id,
			style: .grouped,
			accessoryInfo: accessoryInfo,
			accessibilityTraits: .button,
			backgroundColorHandler: { cellState in
				if cellState.isHighlighted {
					return ColorStyle.brand.highlightedColor
				}

				return ColorStyle.brand.color
			},
			pointerInteractionDelegate: pointerInteractionDelegate,
			textAlignment: textAlignment,
			textColorStyle: .labelOnBrand,
			textFontStyle: textFontStyle,
			tintColorStyle: .labelOnBrand
		)
	}
}
