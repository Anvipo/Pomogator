//
//  Decimal+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 13.11.2022.
//

import Foundation

extension Decimal {
	var doubleValue: Double {
		nsDecimalNumber.doubleValue
	}

	var stringValue: String {
		nsDecimalNumber.stringValue
	}

	var hasFraction: Bool {
		floor(doubleValue) != doubleValue
	}

	var absolute: Decimal {
		abs(self)
	}

	var intValue: Int {
		// Важно не использовать -[NSDecimalNumber intValue] тк он работает некорректно в некоторых случаях
		// https://stackoverflow.com/a/26809965
		Int(nsDecimalNumber.doubleValue)
	}
}
