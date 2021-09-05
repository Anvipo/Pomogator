//
//  MainSection.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//

import Foundation

enum MainSectionIdentifier: Hashable {
	case poedator
}

enum MainHeaderItemIdentifier: Hashable {
	case poedator
}

enum MainItemIdentifier: Hashable {
	case poedator(nextMealTime: Date?)
}

typealias MainSection = TableViewSection<
	MainSectionIdentifier,
	MainItemIdentifier
>
