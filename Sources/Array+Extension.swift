//
//  Array+Extension.swift
//  Pomogator
//
//  Created by Anvipo on 07.01.2023.
//

import Foundation

extension Array {
	var firstElementIndex: Index {
		startIndex
	}

	var lastElementIndex: Index {
		if isEmpty {
			return firstElementIndex
		}

		return endIndex - 1
	}
}

extension Array where Element == Date {
	func nearest(from date: Date) -> Date? {
		sorted().first { $0.timeIntervalSince(date) > 0 }
	}
}
