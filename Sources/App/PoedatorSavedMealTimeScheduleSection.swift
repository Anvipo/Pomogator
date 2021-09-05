//
//  PoedatorSavedMealTimeScheduleSection.swift
//  App
//
//  Created by Anvipo on 27.08.2022.
//

import UIKit

enum PoedatorSavedMealTimeScheduleSectionIdentifier: Hashable {
	// ассоциативное значение для того, чтобы хедер обновлялся вслед за контентом, если формат отображения изменился
	case savedMealTimeSchedule(headerID: PoedatorSavedMealTimeScheduleHeaderItemIdentifier)
}

enum PoedatorSavedMealTimeScheduleHeaderItemIdentifier: Hashable {
	case savedMealTimeSchedule(text: String)
}

enum PoedatorSavedMealTimeScheduleItemIdentifier: Hashable {
	case calculatedMealTime(Date, isNext: Bool)
}

extension PoedatorSavedMealTimeScheduleItemIdentifier {
	var calculatedMealTime: Date {
		switch self {
		case let .calculatedMealTime(date, _): date
		}
	}

	func copy(newIsNext: Bool) -> Self {
		switch self {
		case let .calculatedMealTime(date, _):  .calculatedMealTime(date, isNext: newIsNext)
		}
	}
}

extension PoedatorCalculateMealTimeScheduleItemIdentifier {
	var savedMealTimeScheduleAnalog: PoedatorSavedMealTimeScheduleItemIdentifier {
		switch self {
		case let .calculatedMealTime(mealTime, isNext): .calculatedMealTime(mealTime, isNext: isNext)
		default: fatalError("?")
		}
	}
}

typealias PoedatorSavedMealTimeScheduleSection = TableViewSection<
	PoedatorSavedMealTimeScheduleSectionIdentifier,
	PoedatorSavedMealTimeScheduleItemIdentifier
>

extension PoedatorSavedMealTimeScheduleSection {
	var castedItems: [PlainLabelItem<ItemID>] {
		get {
			items.map { $0.base as! PlainLabelItem<ItemID> }
		}
		set {
			items = newValue.map { $0.eraseToAnyTableItem() }
		}
	}
}
