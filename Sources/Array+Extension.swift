//
//  Array+Extension.swift
//  Pomogator
//
//  Created by Anvipo on 07.01.2023.
//

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

	var penultimateElementIndex: Index {
		if isEmpty {
			return firstElementIndex
		}

		return lastElementIndex - 1
	}

	/// Разбивает массив на массивы с указанным размером.
	/// [1, 2, 3, 4, 5] -> [[1, 2], [3, 4], [5]]
	func split(batchSize: Int) -> [[Element]] {
		var batches: [[Element]] = []
		var batch: [Element] = []

		for element in self {
			batch.append(element)

			if batch.count == batchSize {
				batches.append(batch)
				batch = []
			}
		}

		if !batch.isEmpty {
			batches.append(batch)
		}

		return batches
	}

	/// Перемещает элемент со старого индекса на новый.
	mutating func move(from oldIndex: Index, to newIndex: Index) {
		guard oldIndex != newIndex else {
			return
		}

		guard indices ~= oldIndex,
			  indices ~= newIndex
		else {
			assertionFailure("?")
			return
		}

		if abs(newIndex - oldIndex) == 1 {
			swapAt(oldIndex, newIndex)
		} else {
			let element = remove(at: oldIndex)
			insert(element, at: newIndex)
		}
	}
}

extension Array where Element: Equatable {
	mutating func removeObject(_ element: Element) {
		if let index = firstIndex(of: element) {
			remove(at: index)
		}
	}

	/// Получение элементов повторяющихся в обоих массивах
	func intersection(_ other: [Element]) -> [Element] {
		filter { other.contains($0) }
	}
}

// swiftlint:disable discouraged_optional_boolean
extension Array where Element == Bool {
	/// Логическое И по всем элементам
	/// в случае пустого массива возвращает nil
	var conjunction: Bool? {
		if isEmpty {
			return nil
		}

		return !contains(false)
	}

	/// Логическое ИЛИ по всем элементам
	/// в слуючае пустого массива возвращает nil
	var disjunction: Bool? {
		if isEmpty {
			return nil
		}

		return contains(true)
	}

	/// Логическое И по всем элементам
	/// в случае пустого массива возвращает defaultValue
	func conjunction(defaultValue: Bool) -> Bool {
		conjunction ?? defaultValue
	}

	/// Логическое ИЛИ по всем элементам
	/// в слуючае пустого массива возвращает defaultValue
	func disjunction(defaultValue: Bool) -> Bool {
		disjunction ?? defaultValue
	}
}
// swiftlint:enable discouraged_optional_boolean
