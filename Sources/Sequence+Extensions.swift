//
//  Sequence+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 28.08.2022.
//

import Foundation

extension Sequence {
	func asyncMap<T>(
		_ transform: (Element) async throws -> T
	) async rethrows -> [T] {
		var values = [T]()

		for element in self {
			try await values.append(transform(element))
		}

		return values
	}

	/// Возвращает словарь, где ключ - свойство, по которому сгруппирован массив, лежащий в значении
	/// Возвращает HashMap с разбивкой по заданному атрибуту. e.g. [2,3,4,5,6].split(by: { $0 % 2 == 0 }) -> [true: [2,4,6], false: [3,5]]
	func grouped<T: Hashable>(by uniqueAttribute: ((Element) -> T)) -> [T: [Element]] {
		var result: [T: [Element]] = [:]

		forEach { element in
			let key = uniqueAttribute(element)
			if result[key] == nil {
				result[key] = []
			}
			result[key]?.append(element)
		}

		return result
	}

	/// Возвращает массив, отсортированный по заданному свойству
	func sorted<T: Comparable>(by comparableAttribute: ((Element) -> T?), ascending: Bool = true) -> [Element] {
		sorted { _lhs, _rhs in
			let lhs = comparableAttribute(_lhs)
			let rhs = comparableAttribute(_rhs)

			if let lhs, let rhs {
				return ascending ? lhs < rhs : lhs > rhs
			} else if lhs != nil {
				return ascending
			} else if rhs != nil {
				return !ascending
			} else {
				return false
			}
		}
	}

	/// Возвращает массив, отсортированный c заданными дескрипторами
	func sorted(using sortDescriptors: [NSSortDescriptor]) -> [Element] {
		sorted { lhs, rhs in
			for sortDescriptor in sortDescriptors {
				switch sortDescriptor.compare(lhs, to: rhs) {
				case .orderedAscending:
					return true

				case .orderedDescending:
					return false

				case .orderedSame:
					continue
				}
			}

			return true
		}
	}
}

extension Sequence where Element: OptionSet {
	var joined: Element {
		reduce(into: []) { $0 = $0.union($1) }
	}
}

extension Sequence where Element: Equatable {
	var uniqued: [Element] {
		var alreadyAdded = [Element]()
		return filter { element in
			let result = !alreadyAdded.contains(element)
			alreadyAdded.append(element)
			return result
		}
	}
}

extension Sequence where Element: BinaryFloatingPoint {
	var sum: Element {
		reduce(0, +)
	}
}

extension Sequence where Element: BinaryInteger {
	var sum: Element {
		reduce(0, +)
	}
}
