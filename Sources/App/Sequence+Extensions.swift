//
//  Sequence+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 12.11.2023.
//

extension Sequence where Element: AdditiveArithmetic {
	var sum: Element {
		reduce(.zero, +)
	}
}

extension Sequence where Element: Hashable {
	var frequency: [Element: Int] {
		reduce(into: [:]) { $0[$1, default: 0] += 1 }
	}

	var modes: (mostFrequent: [Element], count: Int)? {
		guard let maxCount = frequency.values.max() else {
			return nil
		}

		return (frequency.compactMap { $0.value == maxCount ? $0.key : nil }, maxCount)
	}

	var mode: Element? {
		modes?.mostFrequent.first
	}
}
