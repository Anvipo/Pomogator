//
//  LegacyExtensions.swift
//  Pomogator
//
//  Created by Anvipo on 10.01.2023.
//
// swiftlint:disable legacy_objc_type

import Foundation

extension Int {
	var nsNumberValue: NSNumber {
		self as NSNumber
	}
}

extension Double {
	var nsNumberValue: NSNumber {
		self as NSNumber
	}
}

extension Float {
	var nsNumberValue: NSNumber {
		self as NSNumber
	}
}

extension Decimal {
	var nsNumberValue: NSNumber {
		self as NSNumber
	}

	var nsDecimalNumber: NSDecimalNumber {
		self as NSDecimalNumber
	}
}
