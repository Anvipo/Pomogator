//
//  VychislyatorBodyMassIndexSection.swift
//  Pomogator
//
//  Created by Anvipo on 22.12.2022.
//

enum VychislyatorBodyMassIndexSectionIdentifier: Hashable {
	case parameters
	case result
}

enum VychislyatorBodyMassIndexHeaderItemIdentifier: Hashable {
	case parameters
	case result
}

enum VychislyatorBodyMassIndexItemIdentifier: Hashable {
	case massInKg
	case heightInCm

	case result(text: String)
}

typealias VychislyatorBodyMassIndexSection = TableViewSection<
	VychislyatorBodyMassIndexSectionIdentifier,
	VychislyatorBodyMassIndexItemIdentifier
>
