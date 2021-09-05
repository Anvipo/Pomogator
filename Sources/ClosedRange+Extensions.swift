//
//  ClosedRange+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

extension ClosedRange {
	init?(safe bounds: (lower: Bound, upper: Bound)) {
		guard bounds.lower <= bounds.upper else {
			assertionFailure("ClosedRange initialization failure. Lower bound is greater than upper bound")
			return nil
		}

		self.init(uncheckedBounds: bounds)
	}

	func contains(_ range: ClosedRange<Bound>) -> Bool {
		contains(range.lowerBound) && contains(range.upperBound)
	}
}
