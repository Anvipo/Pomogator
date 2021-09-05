//
//  PoedatorYourMealTimeListSection.swift
//  Pomogator
//
//  Created by Anvipo on 27.08.2022.
//

import Foundation

enum PoedatorYourMealTimeListSectionIdentifier: Hashable {
	case calculatedMealTimeList
}

enum PoedatorYourMealTimeListHeaderItemIdentifier: Hashable {
	case calculatedMealTimeList
}

enum PoedatorYourMealTimeListItemIdentifier: Hashable {
	case calculatedMealTime(date: Date)
}

// swiftlint:disable:next file_types_order
extension PoedatorCalculateMealTimeListItemIdentifier {
	var yourMealTimeListAnalog: PoedatorYourMealTimeListItemIdentifier {
		switch self {
		case let .calculatedMealTime(date):
			return .calculatedMealTime(date: date)

		default:
			fatalError("?")
		}
	}
}

typealias PoedatorYourMealTimeListSection = TableViewSection<
	PoedatorYourMealTimeListSectionIdentifier,
	PoedatorYourMealTimeListItemIdentifier
>
