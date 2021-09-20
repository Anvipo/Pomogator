//
//  UserDefaults+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import Foundation

extension UserDefaults {
	func uint(forKey key: String) -> UInt? {
		object(forKey: key) as? UInt
	}

	func decimal(forKey key: String) -> Decimal? {
		// swiftlint:disable:next legacy_objc_type
		(object(forKey: key) as? NSNumber)?.decimalValue
	}

	func date(forKey key: String) -> Date? {
		object(forKey: key) as? Date
	}

	func dates(forKey key: String) -> [Date] {
		(array(forKey: key) as? [Date]) ?? []
	}
}
