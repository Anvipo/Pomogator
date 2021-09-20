//
//  MainSection.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//

import Foundation

enum MainSectionIdentifier: Hashable {
	case poedator

	case dailyCalorieIntakeMifflinStJeorKcNormalValue

	case bodyMassIndex
}

enum MainHeaderItemIdentifier: Hashable {
	case poedator

	case dailyCalorieIntakeMifflinStJeorKcNormalValue
}

enum MainItemIdentifier: Hashable {
	case poedator(nextMealTime: Date?)

	case dailyCalorieIntakeMifflinStJeorKcNormalValue(mifflinStJeorKcNormalValue: Decimal?)

	case bodyMassIndex(calculatedBodyMassIndex: Decimal?)
}

typealias MainSection = TableViewSection<
	MainSectionIdentifier,
	MainItemIdentifier
>
