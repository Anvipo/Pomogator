//
//  PoedatorCalculateMealTimeScheduleSection.swift
//  Pomogator
//
//  Created by Anvipo on 21.08.2022.
//

import Foundation

enum PoedatorCalculateMealTimeScheduleSectionIdentifier: Hashable {
	case parameters
	case calculatedMealTimeSchedule
}

enum PoedatorCalculateMealTimeScheduleHeaderItemIdentifier: Hashable {
	case parameters
	case calculatedMealTimeSchedule
}

enum PoedatorCalculateMealTimeScheduleItemIdentifier: Hashable {
	case numberOfMealTime
	case firstMealTime
	case lastMealTime

	case calculatedMealTime(id: UUID)
}

typealias PoedatorCalculateMealTimeScheduleSection = TableViewSection<
	PoedatorCalculateMealTimeScheduleSectionIdentifier,
	PoedatorCalculateMealTimeScheduleItemIdentifier
>
