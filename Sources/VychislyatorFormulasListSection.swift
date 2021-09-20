//
//  VychislyatorFormulasListSection.swift
//  Pomogator
//
//  Created by Anvipo on 10.09.2022.
//

enum VychislyatorFormulasListSectionIdentifier: Hashable {
	case formulas
}

enum VychislyatorFormulasListItemIdentifier: Hashable {
	case dailyCalorieIntake
	case spacer1
	case bodyMassIndex
}

typealias VychislyatorFormulasListSection = TableViewSection<
	VychislyatorFormulasListSectionIdentifier,
	VychislyatorFormulasListItemIdentifier
>
