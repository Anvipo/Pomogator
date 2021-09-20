//
//  VychislyatorBodyMassIndexAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 22.12.2022.
//

import UIKit

final class VychislyatorBodyMassIndexAssembly: BaseAssembly {}

extension VychislyatorBodyMassIndexAssembly {
	var decimalFormatStyle: Decimal.FormatStyle {
		.number
	}

	func initialParametersSection(
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		currentMassInKg: Decimal?,
		massInKgItemDelegate: StringFieldItemDelegate
	) -> (
		massInKgItem: StringFieldItem<VychislyatorBodyMassIndexItemIdentifier>,
		parametersSection: VychislyatorBodyMassIndexSection
	) {
		var massInKgItem = Pomogator.stringFieldItem(
			id: VychislyatorBodyMassIndexItemIdentifier.massInKg,
			content: StringFieldItem.Content(
				icon: Image.scaleMass.uiImage,
				title: String(localized: "Mass (in kg)"),
				text: currentMassInKg?.formatted(decimalFormatStyle) ?? ""
			),
			textKeyboardType: .decimalPad,
			delegate: massInKgItemDelegate
		)

		Pomogator.configureToolbarItems(
			in: &massInKgItem,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		return (
			massInKgItem,
			// swiftlint:disable:next force_try
			try! VychislyatorBodyMassIndexSection(
				id: .parameters,
				items: [massInKgItem],
				headerItem: Pomogator.headerItem(
					id: VychislyatorBodyMassIndexHeaderItemIdentifier.parameters,
					text: String(localized: "Parameters section header")
				)
			)
		)
	}

	func heightInCmItem(
		delegate: StringFieldItemDelegate,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		currentHeightInCm: Decimal?
	) -> StringFieldItem<VychislyatorBodyMassIndexItemIdentifier> {
		var heightInCmItem = Pomogator.stringFieldItem(
			id: VychislyatorBodyMassIndexItemIdentifier.heightInCm,
			content: StringFieldItem.Content(
				icon: Image.rulerFigure.uiImage,
				title: String(localized: "Height (in cm)"),
				text: currentHeightInCm?.formatted(decimalFormatStyle) ?? ""
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

	func resultSectionItem(bodyMassIndexInfo: BodyMassIndexInfo) -> PlainTextItem<VychislyatorBodyMassIndexItemIdentifier> {
		Pomogator.textItem(
			id: VychislyatorBodyMassIndexItemIdentifier.result(text: bodyMassIndexInfo.text),
			text: bodyMassIndexInfo.text,
			secondaryText: bodyMassIndexInfo.secondaryText,
			textColor: bodyMassIndexInfo.textColor
		)
	}

	func resultSection(bodyMassIndexInfo: BodyMassIndexInfo) -> VychislyatorBodyMassIndexSection {
		// swiftlint:disable:next force_try
		try! VychislyatorBodyMassIndexSection(
			id: .result,
			items: [resultSectionItem(bodyMassIndexInfo: bodyMassIndexInfo)].eraseToAnyTableItems(),
			headerItem: Pomogator.headerItem(
				id: VychislyatorBodyMassIndexHeaderItemIdentifier.result,
				text: String(localized: "Result section header")
			)
		)
	}
}
