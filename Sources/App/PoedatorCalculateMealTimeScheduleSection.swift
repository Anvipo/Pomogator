//
//  PoedatorCalculateMealTimeScheduleSection.swift
//  App
//
//  Created by Anvipo on 21.08.2022.
//

import UIKit

enum PoedatorCalculateMealTimeScheduleSectionIdentifier: Hashable {
	case parameters(id: UUID = UUID())
	// ассоциативное значение для того, чтобы хедер обновлялся вслед за контентом, если формат отображения изменился
	case calculatedMealTimeSchedule(headerID: PoedatorCalculateMealTimeScheduleHeaderItemIdentifier)
}

enum PoedatorCalculateMealTimeScheduleHeaderItemIdentifier: Hashable {
	case parameters
	case calculatedMealTimeSchedule(text: String)
}

enum PoedatorCalculateMealTimeScheduleItemIdentifier: Hashable {
	case numberOfMealTime
	case firstMealTime
	case lastMealTime
	case shouldAutoDeleteSchedule

	case calculatedMealTime(Date, isNext: Bool)
}

typealias PoedatorCalculateMealTimeScheduleSection = TableViewSection<
	PoedatorCalculateMealTimeScheduleSectionIdentifier,
	PoedatorCalculateMealTimeScheduleItemIdentifier
>
