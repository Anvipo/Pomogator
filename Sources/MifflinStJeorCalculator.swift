//
//  MifflinStJeorCalculator.swift
//  Pomogator
//
//  Created by Anvipo on 27.09.2021.
//

import Foundation

final class MifflinStJeorCalculator {}

extension MifflinStJeorCalculator {
	func kilocalories(
		massInKg: Decimal,
		heightInCm: Decimal,
		ageInYears: Decimal,
		selectedPersonSex: PersonSex,
		selectedPhysicalActivity: PhysicalActivity
	) -> Decimal {
		let commonPart =
		("10".decimalFromEN * massInKg) +
		("6.25".decimalFromEN * heightInCm) -
		("5".decimalFromEN * ageInYears)

		let personSexCorrectedPart: Decimal
		switch selectedPersonSex {
		case .male:
			personSexCorrectedPart = commonPart + "5".decimalFromEN

		case .female:
			personSexCorrectedPart = commonPart - "161".decimalFromEN
		}

		let result = personSexCorrectedPart * selectedPhysicalActivity.value

		return max(result, selectedPersonSex.kilocaloriesMinimum)
	}

	func format(kilocalories: Decimal, selectedPersonSex: PersonSex) -> String {
		let value = max(kilocalories, selectedPersonSex.kilocaloriesMinimum).doubleValue

		return Measurement<UnitEnergy>(value: value, unit: .kilocalories)
			.formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number))
	}
}
