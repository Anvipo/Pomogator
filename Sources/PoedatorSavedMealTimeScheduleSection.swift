//
//  PoedatorSavedMealTimeScheduleSection.swift
//  Pomogator
//
//  Created by Anvipo on 27.08.2022.
//

import Foundation

enum PoedatorSavedMealTimeScheduleSectionIdentifier: Hashable {
	case savedMealTimeSchedule
}

enum PoedatorSavedMealTimeScheduleHeaderItemIdentifier: Hashable {
	case savedMealTimeSchedule
}

enum PoedatorSavedMealTimeScheduleItemIdentifier: Hashable {
	case calculatedMealTime(id: UUID)
}

// swiftlint:disable:next file_types_order
extension PoedatorCalculateMealTimeScheduleItemIdentifier {
	var savedMealTimeScheduleAnalog: PoedatorSavedMealTimeScheduleItemIdentifier {
		switch self {
		case let .calculatedMealTime(id):
			return .calculatedMealTime(id: id)

		default:
			fatalError("?")
		}
	}
}

typealias PoedatorSavedMealTimeScheduleSection = TableViewSection<
	PoedatorSavedMealTimeScheduleSectionIdentifier,
	PoedatorSavedMealTimeScheduleItemIdentifier
>
