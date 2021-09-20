//
//  String+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 30.08.2021.
//

import Foundation

extension String {
	var decimalFromEN: Decimal {
		let result = Decimal(string: self)

		if result == nil {
			assertionFailure("?")
		}

		return result ?? 0
	}
}
