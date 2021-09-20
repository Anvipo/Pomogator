//
//  MainAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit

final class MainAssembly: BaseAssembly {}

extension MainAssembly {
	var emptyPoedatorSection: MainSection {
		// swiftlint:disable:next force_try
		try! MainSection(
			id: .poedator,
			items: [
				emptySectionLabelItem(
					id: MainItemIdentifier.poedator(calculatedMealTimeList: []),
					text: String(localized: "No calculated meal times")
				)
			],
			headerItem: PlainLabelHeaderItem(
				id: MainHeaderItemIdentifier.poedator,
				text: String(localized: "Poedator")
			)
		)
	}

	func poedatorSection(
		for calculatedMealTimeList: [Date],
		isMealTimeListInSameDay: Bool
	) -> MainSection {
		// swiftlint:disable:next force_try
		try! MainSection(
			id: .poedator,
			items: [
				calculatedFirstMealTimeItem(
					for: calculatedMealTimeList,
					isMealTimeListInSameDay: isMealTimeListInSameDay
				)
			],
			headerItem: PlainLabelHeaderItem(
				id: MainHeaderItemIdentifier.poedator,
				text: String(localized: "Poedator")
			)
		)
	}
}

extension MainAssembly {
	func mifflinStJeorKcNormalValueSection(
		calculatedMifflinStJeorKcNormalValue: Decimal?,
		selectedPersonSex: PersonSex?
	) -> MainSection {
		let mifflinStJeorKcNormalValueItem: any ReusableTableViewItem
		let footerItem: (any ReusableTableViewHeaderFooterItem)?
		if let calculatedMifflinStJeorKcNormalValue, let selectedPersonSex {
			let mifflinStJeorCalculator = MifflinStJeorCalculator()
			let text = mifflinStJeorCalculator.format(
				kilocalories: calculatedMifflinStJeorKcNormalValue,
				selectedPersonSex: selectedPersonSex
			)

			let assembly = VychislyatorDailyCalorieIntakeFormulasListAssembly()
			var mifflinStJeorSectionFooterItem = assembly.mifflinStJeorSectionFooterItem
			mifflinStJeorSectionFooterItem.textColor = Color.label.uiColor
			footerItem = mifflinStJeorSectionFooterItem

			mifflinStJeorKcNormalValueItem = labelItem(
				id: MainItemIdentifier.dailyCalorieIntakeMifflinStJeorKcNormalValue(
					mifflinStJeorKcNormalValue: calculatedMifflinStJeorKcNormalValue
				),
				text: text,
				textAlignment: Pomogator.defaultLabelTextAlignment,
				textFont: Pomogator.defaultLabelTextFont.uiFont
			)
		} else {
			mifflinStJeorKcNormalValueItem = emptyMifflinStJeorKcNormalValueItem
			footerItem = nil
		}

		// swiftlint:disable:next force_try
		return try! MainSection(
			id: .dailyCalorieIntakeMifflinStJeorKcNormalValue,
			items: [mifflinStJeorKcNormalValueItem],
			headerItem: PlainLabelHeaderItem(
				id: MainHeaderItemIdentifier.dailyCalorieIntakeMifflinStJeorKcNormalValue,
				text: String(localized: "Vychislyator")
			),
			footerItem: footerItem
		)
	}

	func bodyMassIndexSection(
		calculatedBodyMassIndex: Decimal?
	) -> MainSection {
		let bmiItem: any ReusableTableViewItem
		if let calculatedBodyMassIndex {
			let assembly = VychislyatorBodyMassIndexAssembly()
			let bodyMassIndexCalculator = BodyMassIndexCalculator()
			let bodyMassIndexInfo = bodyMassIndexCalculator.bodyMassIndexInfo(from: calculatedBodyMassIndex)

			let resultSectionItem = assembly.resultSectionItem(bodyMassIndexInfo: bodyMassIndexInfo)
			bmiItem = labelItem(
				id: MainItemIdentifier.bodyMassIndex(calculatedBodyMassIndex: calculatedBodyMassIndex),
				text: String(localized: "BMI: \(resultSectionItem.content.text)"),
				textAlignment: Pomogator.defaultLabelTextAlignment,
				textFont: Pomogator.defaultLabelTextFont.uiFont
			)
		} else {
			bmiItem = emptyBMIItem
		}

		// swiftlint:disable:next force_try
		return try! MainSection(
			id: .bodyMassIndex,
			items: [bmiItem]
		)
	}
}

private extension MainAssembly {
	var emptyMifflinStJeorKcNormalValueItem: any ReusableTableViewItem {
		emptySectionLabelItem(
			id: MainItemIdentifier.dailyCalorieIntakeMifflinStJeorKcNormalValue(mifflinStJeorKcNormalValue: nil),
			text: String(localized: "No calculated daily calorie intake value")
		)
	}

	var emptyBMIItem: any ReusableTableViewItem {
		emptySectionLabelItem(
			id: MainItemIdentifier.bodyMassIndex(calculatedBodyMassIndex: nil),
			text: String(localized: "No calculated body mass index value")
		)
	}

	func emptySectionLabelItem<ID: IDType>(
		id: ID,
		text: String
	) -> PlainLabelItem<ID> {
		labelItem(
			id: id,
			text: text,
			textAlignment: .natural,
			textFont: Font.body.uiFont
		)
	}

	func labelItem<ID: IDType>(
		id: ID,
		text: String,
		textAlignment: UIListContentConfiguration.TextProperties.TextAlignment,
		textFont: UIFont
	) -> PlainLabelItem<ID> {
		Pomogator.labelItem(
			id: id,
			text: text,
			accessoryInfo: .accessoryView(UIImageView(image: Image.chevronRight.uiImage)),
			backgroundColorHandler: { cellState in
				if cellState.isHighlighted {
					return Color.brand.highlightedUIColor
				} else {
					return Color.brand.uiColor
				}
			},
			textAlignment: textAlignment,
			textColor: Color.labelOnBrand.uiColor,
			textFont: textFont,
			tintColor: Color.labelOnBrand.uiColor
		)
	}

	func calculatedFirstMealTimeItem(
		for calculatedMealTimeList: [Date],
		isMealTimeListInSameDay: Bool
	) -> PlainLabelItem<MainItemIdentifier> {
		guard let firstMealTime = calculatedMealTimeList.first else {
			fatalError("?")
		}

		return PoedatorCalculateMealTimeListAssembly().calculatedMealTimeListItems(
			for: [firstMealTime],
			isMealTimeListInSameDay: isMealTimeListInSameDay
		)
		.map { item in
			labelItem(
				id: .poedator(calculatedMealTimeList: calculatedMealTimeList),
				text: item.text,
				textAlignment: item.textAlignment,
				textFont: item.textFont
			)
		}
		// swiftlint:disable:next force_unwrapping
		.first!
	}
}
