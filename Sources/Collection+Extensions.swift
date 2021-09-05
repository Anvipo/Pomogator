//
//  Collection+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

// MARK: - Safe subscripts extensions

extension Collection {
	subscript(safe index: Index) -> Element? {
		indices.contains(index) ? self[index] : nil
	}
}

extension MutableCollection {
	subscript(safe index: Index) -> Element? {
		get {
			indices.contains(index) ? self[index] : nil
		}
		set {
			if let newValue, indices.contains(index) {
				self[index] = newValue
			}
		}
	}
}

// MARK: - Math extensions

extension Collection where Element: BinaryFloatingPoint {
	var average: Element {
		sum / Element(count)
	}
}

extension Collection where Element: BinaryInteger {
	var average: Element {
		sum / Element(count)
	}
}
