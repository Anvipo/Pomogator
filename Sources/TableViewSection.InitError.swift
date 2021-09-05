//
//  TableViewSection.InitError.swift
//  Pomogator
//
//  Created by Anvipo on 26.11.2022.
//

import Foundation

// swiftlint:disable:next file_types_order
extension TableViewSection {
	enum InitError {
		case emptyItems
	}
}

extension TableViewSection.InitError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .emptyItems:
			return "Specified items are empty"
		}
	}
}
