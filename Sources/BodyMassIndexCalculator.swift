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
		let title: String
		let textColor: UIColor
		if bodyMassIndex < 16 {
			title = String(localized: "Severe deficiency of body mass")
			textColor = .systemBlue
		} else if 16 <= bodyMassIndex && bodyMassIndex < 18.5 {
			title = String(localized: "Deficiency of body mass")
			textColor = .systemCyan
		} else if 18.5 <= bodyMassIndex && bodyMassIndex < 25 {
			title = String(localized: "Normal body mass")
			textColor = .systemGreen
		} else if 25 <= bodyMassIndex && bodyMassIndex < 30 {
			title = String(localized: "Excess body mass")
			textColor = .systemOrange
		} else if 30 <= bodyMassIndex && bodyMassIndex < 35 {
			title = String(localized: "First degree obesity")
			textColor = .systemPink
		} else if 35 <= bodyMassIndex && bodyMassIndex < 40 {
			title = String(localized: "Second degree obesity")
			textColor = .systemRed
		} else {
			title = String(localized: "Third degree obesity")
			textColor = .systemPurple
		}
		// swiftlint:enable yoda_condition

		let formatStyle = Decimal.FormatStyle().precision(.fractionLength(.bodyMassIndexFractionLength))
		let text = bodyMassIndex.formatted(formatStyle)

		return BodyMassIndexInfo(title: title, text: text, textColor: textColor)
	}
}

private extension Int {
	static var bodyMassIndexFractionLength: Int {
		1
	}
}
