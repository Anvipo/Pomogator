//
//  PoedatorSavedMealTimeScheduleViewModelFactory.swift
//  App
//
//  Created by Anvipo on 25.09.2021.
//

import Foundation

final class PoedatorSavedMealTimeScheduleViewModelFactory {
	private let calculateMealTimeScheduleViewModelFactory: PoedatorCalculateMealTimeScheduleViewModelFactory

	init(calculateMealTimeScheduleViewModelFactory: PoedatorCalculateMealTimeScheduleViewModelFactory) {
		self.calculateMealTimeScheduleViewModelFactory = calculateMealTimeScheduleViewModelFactory
	}
}

extension PoedatorSavedMealTimeScheduleViewModelFactory {
	func calculatedMealTimeScheduleSection(
		for mealTimeSchedule: PoedatorMealTimeSchedule
	) throws -> PoedatorSavedMealTimeScheduleSection {
		let headerItem = try headerItem(for: mealTimeSchedule)

		return try PoedatorSavedMealTimeScheduleSection(
			id: .savedMealTimeSchedule(headerID: headerItem.id),
			items: calculatedMealTimeScheduleItems(for: mealTimeSchedule),
			headerItem: headerItem
		)
	}
}

private extension PoedatorSavedMealTimeScheduleViewModelFactory {
	func headerItem(
		for mealTimeSchedule: PoedatorMealTimeSchedule
	) throws -> PlainLabelHeaderItem<PoedatorSavedMealTimeScheduleHeaderItemIdentifier> {
		let calculateMealTimeScheduleHeaderItem = try calculateMealTimeScheduleViewModelFactory.headerItem(
			for: mealTimeSchedule
		)

		guard case let .calculatedMealTimeSchedule(text) = calculateMealTimeScheduleHeaderItem.id else {
			fatalError("?")
		}

		return Pomogator.headerItem(
			content: .init(
				accessibilityLabel: calculateMealTimeScheduleHeaderItem.content.accessibilityLabel,
				text: calculateMealTimeScheduleHeaderItem.content.text
			),
			id: .savedMealTimeSchedule(text: text),
			style: calculateMealTimeScheduleHeaderItem.style
		)
	}

	func calculatedMealTimeScheduleItems(
		for mealTimeSchedule: PoedatorMealTimeSchedule
	) -> [PlainLabelItem<PoedatorSavedMealTimeScheduleItemIdentifier>] {
		calculateMealTimeScheduleViewModelFactory.calculatedMealTimeScheduleItems(
			for: mealTimeSchedule
		)
		.map { oldItem in
			PlainLabelItem(
				accessoryInfo: oldItem.accessoryInfo,
				accessibilityTraits: oldItem.accessibilityTraits,
				backgroundColorHandler: oldItem.backgroundColorHandler,
				content: .init(
					text: oldItem.content.text,
					customAccessibilityLabel: oldItem.content.customAccessibilityLabel,
					customAccessibilityValue: oldItem.content.customAccessibilityValue
				),
				id: oldItem.id.savedMealTimeScheduleAnalog,
				pointerInteractionDelegate: oldItem.pointerInteractionDelegate,
				style: oldItem.style,
				textProperties: oldItem.textProperties,
				tintColorStyle: oldItem.tintColorStyle
			)
		}
	}
}
