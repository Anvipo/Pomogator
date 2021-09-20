//
//  VychislyatorDailyCalorieIntakeFormulasListAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//
// swiftlint:disable function_parameter_count trailing_closure large_tuple

import UIKit

final class VychislyatorDailyCalorieIntakeFormulasListAssembly: BaseAssembly {}

extension VychislyatorDailyCalorieIntakeFormulasListAssembly {
	var mifflinStJeorSectionFooterItem: PlainLabelFooterItem<VychislyatorDailyCalorieIntakeFormulasListHeaderItemIdentifier> {
		Pomogator.footerItem(
			id: VychislyatorDailyCalorieIntakeFormulasListHeaderItemIdentifier.mifflinStJeor,
			text: String(localized: "Mifflin-St. Jeor's section footer"),
			textColor: Color.brand.uiColor
		)
	}

	func initialParametersSection(
		inputedAgeInYears: UInt?,
		personSexes: [PersonSex],
		selectedPersonSex: PersonSex,
		personSexItemDelegate: PickerFieldItemDelegate,
		ageInYearsItemDelegate: StringFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> (
		personSexItem: PersonSexPickerFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier>,
		ageInYearsItem: StringFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier>,
		parametersSection: VychislyatorDailyCalorieIntakeFormulasListSection
	) {
		var personSexItem = personSexItem(
			personSexes: personSexes,
			selectedPersonSex: selectedPersonSex,
			delegate: personSexItemDelegate
		)
		var ageInYearsItem = ageInYearsItem(inputedAgeInYears: inputedAgeInYears, delegate: ageInYearsItemDelegate)

		Pomogator.configureToolbarItems(
			in: &personSexItem,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator,
			nextResponderNavigationHandler: {
				didTapBarButtonItemFeedbackGenerator.impactOccurred()
				ageInYearsItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
			}
		)

		Pomogator.configureToolbarItems(
			in: &ageInYearsItem,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator,
			previousResponderNavigationHandler: {
				didTapBarButtonItemFeedbackGenerator.impactOccurred()
				personSexItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
			}
		)

		return (
			personSexItem,
			ageInYearsItem,
			// swiftlint:disable:next force_try
			try! VychislyatorDailyCalorieIntakeFormulasListSection(
				id: .parameters,
				items: [
					personSexItem,
					ageInYearsItem
				],
				headerItem: Pomogator.headerItem(
					id: VychislyatorDailyCalorieIntakeFormulasListHeaderItemIdentifier.parameters,
					text: String(localized: "Parameters")
				)
			)
		)
	}

	func heightInCmItem(
		delegate: StringFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		inputedHeightInCm: Decimal?
	) -> StringFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier> {
		var heightInCmItem = Pomogator.stringFieldItem(
			id: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier.heightInCm,
			content: StringFieldItem.Content(
				icon: Image.rulerFigure.uiImage,
				title: String(localized: "Height (in cm)"),
				text: inputedHeightInCm?.formatted(.number) ?? ""
			),
			textKeyboardType: .decimalPad,
			delegate: delegate
		)

		Pomogator.configureToolbarItems(
			in: &heightInCmItem,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		return heightInCmItem
	}

	func massInKgItem(
		delegate: StringFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		inputedMassInKg: Decimal?
	) -> StringFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier> {
		var massInKgItem = Pomogator.stringFieldItem(
			id: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier.massInKg,
			content: StringFieldItem.Content(
				icon: Image.scaleMass.uiImage,
				title: String(localized: "Mass (in kg)"),
				text: inputedMassInKg?.formatted(.number) ?? ""
			),
			textKeyboardType: .decimalPad,
			delegate: delegate
		)

		Pomogator.configureToolbarItems(
			in: &massInKgItem,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		return massInKgItem
	}

	func physicalActivityItem(
		physicalActivities: [PhysicalActivity],
		selectedPhysicalActivity: PhysicalActivity,
		delegate: PickerFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> PhysicalActivityPickerFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier> {
		if physicalActivities.isEmpty {
			assertionFailure("?")
		}

		var physicalActivityItem = Pomogator.physicalActivityPickerFieldItem(
			id: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier.physicalActivity,
			content: PickerFieldItem.Content(
				icon: Image.figureCooldown.uiImage,
				title: String(localized: "Physical activity"),
				data: [physicalActivities]
			),
			selectedComponent: PickerFieldItem.SelectedComponentInfo(
				componentIndex: 0,
				// swiftlint:disable:next force_unwrapping
				componentRowIndex: physicalActivities.firstIndex(of: selectedPhysicalActivity)!
			),
			delegate: delegate
		)

		Pomogator.configureToolbarItems(
			in: &physicalActivityItem,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		return physicalActivityItem
	}

	func mifflinStJeorSection(
		titleForNormalValue: String,
		textForNormalValue: String
	) -> VychislyatorDailyCalorieIntakeFormulasListSection {
		// swiftlint:disable:next force_try
		try! VychislyatorDailyCalorieIntakeFormulasListSection(
			id: .mifflinStJeor,
			items: [
				Pomogator.textItem(
					id: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier.mifflinStJeorNormal(text: textForNormalValue),
					title: titleForNormalValue,
					text: textForNormalValue
				)
			].eraseToAnyTableItems(),
			headerItem: Pomogator.headerItem(
				id: VychislyatorDailyCalorieIntakeFormulasListHeaderItemIdentifier.mifflinStJeor,
				text: String(localized: "Mifflin-St. Jeor's section header")
			),
			footerItem: mifflinStJeorSectionFooterItem
		)
	}

	func basedOnMifflinStJeorSection(
		titleForMassGainValue: String,
		textForMassGainValue: String,

		titleForSafeSlimmingValue: String,
		textForSafeSlimmingValue: String,

		titleForFastSlimmingValue: String,
		textForFastSlimmingValue: String
	) -> VychislyatorDailyCalorieIntakeFormulasListSection {
		// swiftlint:disable:next force_try
		try! VychislyatorDailyCalorieIntakeFormulasListSection(
			id: .basedOnMifflinStJeorSection,
			items: [
				Pomogator.textItem(
					id: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier.mifflinStJeorMassGain(text: textForMassGainValue),
					title: titleForMassGainValue,
					text: textForMassGainValue
				),
				Pomogator.textItem(
					id: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier.mifflinStJeorSafeSlimming(text: textForSafeSlimmingValue),
					title: titleForSafeSlimmingValue,
					text: textForSafeSlimmingValue
				),
				Pomogator.textItem(
					id: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier.mifflinStJeorFastSlimming(text: textForFastSlimmingValue),
					title: titleForFastSlimmingValue,
					text: textForFastSlimmingValue
				)
			].eraseToAnyTableItems(),
			headerItem: Pomogator.headerItem(
				id: VychislyatorDailyCalorieIntakeFormulasListHeaderItemIdentifier.basedOnMifflinStJeorSection,
				text: String(localized: "Based on the Mifflin-St. Jeor's section header")
			),
			footerItem: Pomogator.footerItem(
				id: VychislyatorDailyCalorieIntakeFormulasListHeaderItemIdentifier.basedOnMifflinStJeorSection,
				text: String(localized: "Based on the Mifflin-St. Jeor's section footer"),
				textColor: Color.brand.uiColor
			)
		)
	}
}

private extension VychislyatorDailyCalorieIntakeFormulasListAssembly {
	func personSexItem(
		personSexes: [PersonSex],
		selectedPersonSex: PersonSex,
		delegate: PickerFieldItemDelegate
	) -> PersonSexPickerFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier> {
		if personSexes.isEmpty {
			assertionFailure("?")
		}

		return Pomogator.personSexPickerFieldItem(
			id: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier.personSex,
			content: PickerFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier>.Content(
				icon: Image.figureDressLineVerticalFigure.uiImage,
				title: String(localized: "Sex"),
				data: [personSexes]
			),
			selectedComponent: PickerFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier>.SelectedComponentInfo(
				componentIndex: 0,
				// swiftlint:disable:next force_unwrapping
				componentRowIndex: personSexes.firstIndex(of: selectedPersonSex)!
			),
			delegate: delegate
		)
	}

	func ageInYearsItem(
		inputedAgeInYears: UInt?,
		delegate: StringFieldItemDelegate
	) -> StringFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier> {
		Pomogator.stringFieldItem(
			id: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier.ageInYears,
			content: StringFieldItem.Content(
				icon: Image.personTextRectangle.uiImage,
				title: String(localized: "Age (in years)"),
				text: inputedAgeInYears?.formatted(.number) ?? ""
			),
			textKeyboardType: .numberPad,
			delegate: delegate
		)
	}
}
