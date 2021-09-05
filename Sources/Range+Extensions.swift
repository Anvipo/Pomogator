//
//  Range+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

extension Range {
	/// Safe инициализатор
	init?(safe bounds: (lower: Bound, upper: Bound)) {
		guard bounds.lower <= bounds.upper else {
			assertionFailure("Range initialization failure. Lower bound is greater than upper bound")
			return nil
		}

		self.init(uncheckedBounds: bounds)
	}
}
