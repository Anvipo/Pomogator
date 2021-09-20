//
//  Decimal+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 13.11.2022.
//
// swiftlint:disable legacy_objc_type

import Foundation

extension Decimal {
	var doubleValue: Double {
		nsDecimalNumber.doubleValue
	}

	/// Округляет значение до указанного числа знаков после запятой
	/// - Parameters:
	///   - scale: число знаков после запятой
	///   - roundingMode: режим округления
	func rounded(
		scale: Int,
		roundingMode: NSDecimalNumber.RoundingMode = .plain
	) -> Decimal {
		var result = Decimal()
		var localCopy = self
		NSDecimalRound(&result, &localCopy, scale, roundingMode)
		return result
	}
}
