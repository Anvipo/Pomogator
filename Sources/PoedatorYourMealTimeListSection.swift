//
//  PoedatorYourMealTimeListSection.swift
//  Pomogator
//
//  Created by Anvipo on 27.08.2022.
//
// swiftlint:disable file_types_order

import Foundation

enum PoedatorYourMealTimeListSectionIdentifier: Hashable {
	case calculatedMealTimeList
}

enum PoedatorYourMealTimeListItemIdentifier: Hashable {
	case calculatedMealTime(date: Date)
}

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

typealias AnyPoedatorYourMealTimeListTableItem = AnyTableItem<PoedatorYourMealTimeListItemIdentifier>

typealias PoedatorYourMealTimeListSection = TableViewSection<
	PoedatorYourMealTimeListSectionIdentifier,
	PoedatorYourMealTimeListItemIdentifier
>
