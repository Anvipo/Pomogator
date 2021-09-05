//
//  MainSection.swift
//  App
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit

enum MainSectionIdentifier: Hashable {
	case poedator
}

enum MainHeaderItemIdentifier: Hashable {
	case poedator
}

enum MainItemIdentifier: Hashable {
	case noPoedatorSchedule
	case noPoedatorScheduleForToday
	case noPoedatorActualSchedule
	// isVoiceOverRunning, чтобы избавиться от footer-а в VO
	case poedator(nextMealTime: Date, isVoiceOverRunning: Bool)
}

typealias MainSection = TableViewSection<
	MainSectionIdentifier,
	MainItemIdentifier
>

extension MainSection {
	var castedItems: [PlainLabelItem<ItemID>] {
		get {
			items.map { $0.base as! PlainLabelItem<ItemID> }
		}
		set {
			items = newValue.map { $0.eraseToAnyTableItem() }
		}
	}
}
