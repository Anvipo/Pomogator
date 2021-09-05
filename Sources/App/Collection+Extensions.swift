//
//  Collection+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 12.11.2023.
//

extension Collection {
	var isNotEmpty: Bool {
		!isEmpty
	}
}

extension Collection where Element: BinaryInteger {
	var mean: Element {
		sum / Element(count)
	}

	var median: Element {
		let sortedCollection = sorted()

		let middleIndex = count / 2

		return if count.isMultiple(of: 2) {
			Element(sortedCollection[middleIndex])
		} else {
			Element(sortedCollection[middleIndex] + sortedCollection[middleIndex - 1]) / 2
		}
	}
}

extension Collection where Element: BinaryFloatingPoint {
	var mean: Element {
		sum / Element(count)
	}

	var median: Element {
		let sortedCollection = sorted()

		let middleIndex = count / 2

		return if count.isMultiple(of: 2) {
			Element(sortedCollection[middleIndex])
		} else {
			Element(sortedCollection[middleIndex] + sortedCollection[middleIndex - 1]) / 2
		}
	}
}
