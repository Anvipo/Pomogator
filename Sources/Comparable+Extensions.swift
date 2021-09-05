//
//  Comparable+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 05.01.2023.
//

extension Comparable {
	func normalize(min: Self, max: Self) -> Self {
		if self > max {
			return max
		}

		if self < min {
			return min
		}

		return self
	}
}
