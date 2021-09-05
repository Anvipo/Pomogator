//
//  MainSection.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//
// swiftlint:disable file_types_order

enum MainSectionIdentifier: Hashable {
	case poedator
}

enum MainItemIdentifier: Hashable {
	case poedator
}

extension PoedatorCalculateMealTimeListItemIdentifier {
	var mainAnalog: MainItemIdentifier {
		switch self {
		case .calculatedMealTime:
			return .poedator

		default:
			fatalError("?")
		}
	}
}

typealias AnyMainTableItem = AnyTableItem<MainItemIdentifier>

typealias MainSection = TableViewSection<
	MainSectionIdentifier,
	MainItemIdentifier
>
