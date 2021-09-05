//
//  FloatingPoint+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

extension FloatingPoint {
	var degreesToRadians: Self {
		self * .pi / 180
	}

	var radiansToDegrees: Self {
		self * 180 / .pi
	}

	func rounded(
		to value: Self,
		roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero
	) -> Self {
		(self / value).rounded(roundingRule) * value
	}

	func rounded(
		significantDigitsCount: UInt,
		rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero
	) -> Self {
		var multiplier: Self = 1
		(0 ..< significantDigitsCount).forEach { _ in
			multiplier *= 10
		}

		return (self * multiplier).rounded(rule) / multiplier
	}
}
