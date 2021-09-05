//
//  TableViewSection.InitError.swift
//  App
//
//  Created by Anvipo on 26.11.2022.
//

import Foundation

extension TableViewSection {
	enum InitError {
		case emptyItems
	}
}

extension TableViewSection.InitError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .emptyItems: "Specified items are empty"
		}
	}
}
