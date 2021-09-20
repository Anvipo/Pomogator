//
//  BodyMassIndexCalculator.swift
//  Pomogator
//
//  Created by Anvipo on 22.12.2022.
//

import UIKit

final class BodyMassIndexCalculator {}

extension BodyMassIndexCalculator {
	func bodyMassIndex(massInKg: Decimal, heightInCm: Decimal) -> Decimal {
		let heightInM = heightInCm / 100

		let bodyMassIndex = massInKg / pow(heightInM, 2)

		return bodyMassIndex.rounded(scale: .bodyMassIndexFractionLength)
	}

	func bodyMassIndexInfo(from bodyMassIndex: Decimal) -> BodyMassIndexInfo {
		// swiftlint:disable yoda_condition
		let secondaryText: String
		let textColor: UIColor
		if bodyMassIndex < 16 {
			secondaryText = String(localized: "Severe deficiency of body mass")
			textColor = .systemBlue
		} else if 16 <= bodyMassIndex && bodyMassIndex < 18.5 {
			secondaryText = String(localized: "Deficiency of body mass")
			textColor = .systemCyan
		} else if 18.5 <= bodyMassIndex && bodyMassIndex < 25 {
			secondaryText = String(localized: "Normal body mass")
			textColor = .systemGreen
		} else if 25 <= bodyMassIndex && bodyMassIndex < 30 {
			secondaryText = String(localized: "Excess body mass")
			textColor = .systemOrange
		} else if 30 <= bodyMassIndex && bodyMassIndex < 35 {
			secondaryText = String(localized: "First degree obesity")
			textColor = .systemPink
		} else if 35 <= bodyMassIndex && bodyMassIndex < 40 {
			secondaryText = String(localized: "Second degree obesity")
			textColor = .systemRed
		} else {
			secondaryText = String(localized: "Third degree obesity")
			textColor = .systemPurple
		}
		// swiftlint:enable yoda_condition

		let formatStyle = Decimal.FormatStyle().precision(.fractionLength(.bodyMassIndexFractionLength))
		let text = bodyMassIndex.formatted(formatStyle)

		return BodyMassIndexInfo(text: text, textColor: textColor, secondaryText: secondaryText)
	}
}

private extension Int {
	static var bodyMassIndexFractionLength: Int {
		1
	}
}
