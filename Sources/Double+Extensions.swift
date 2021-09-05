//
//  Double+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

extension Double {
	var intValue: Int {
		Int(self)
	}

	mutating func isEqual(to value: Self, precision: Int = 2) -> Bool {
		let multiplier = Self(10 ^ precision)
		let firstValue = self * multiplier
		let secondValue = value * multiplier

		return firstValue.rounded() == secondValue.rounded()
	}
}
