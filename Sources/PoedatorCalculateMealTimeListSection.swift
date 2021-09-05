//
//  PoedatorCalculateMealTimeListSection.swift
//  Pomogator
//
//  Created by Anvipo on 21.08.2022.
//

import Foundation

enum PoedatorCalculateMealTimeListSectionIdentifier: Hashable {
	case parameters
	case calculatedMealTimeList
}

enum PoedatorCalculateMealTimeListItemIdentifier: Hashable {
	case numberOfMealTime
	case firstMealTime
	case lastMealTime

	case calculatedMealTime(date: Date)
}

typealias AnyPoedatorCalculateMealTimeListTableItem = AnyTableItem<PoedatorCalculateMealTimeListItemIdentifier>

typealias PoedatorCalculateMealTimeListSection = TableViewSection<
	PoedatorCalculateMealTimeListSectionIdentifier,
	PoedatorCalculateMealTimeListItemIdentifier
>
