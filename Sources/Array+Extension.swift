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
}
