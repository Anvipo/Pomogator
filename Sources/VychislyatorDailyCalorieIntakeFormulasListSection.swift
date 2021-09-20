//
//  VychislyatorDailyCalorieIntakeFormulasListSection.swift
//  Pomogator
//
//  Created by Anvipo on 10.09.2022.
//

enum VychislyatorDailyCalorieIntakeFormulasListSectionIdentifier: Hashable {
	case parameters
	case mifflinStJeor
	case basedOnMifflinStJeorSection
}

enum VychislyatorDailyCalorieIntakeFormulasListHeaderItemIdentifier: Hashable {
	case parameters
	case mifflinStJeor
	case basedOnMifflinStJeorSection
}

enum VychislyatorDailyCalorieIntakeFormulasListItemIdentifier: Hashable {
	case personSex
	case ageInYears
	case heightInCm
	case massInKg
	case physicalActivity

	case mifflinStJeorNormal(text: String)

	case mifflinStJeorMassGain(text: String)
	case mifflinStJeorSafeSlimming(text: String)
	case mifflinStJeorFastSlimming(text: String)
}

typealias VychislyatorDailyCalorieIntakeFormulasListSection = TableViewSection<
	VychislyatorDailyCalorieIntakeFormulasListSectionIdentifier,
	VychislyatorDailyCalorieIntakeFormulasListItemIdentifier
>
