//
//  ButtonsView.InitError.swift
//  Pomogator
//
//  Created by Anvipo on 16.11.2021.
//

import Foundation

// swiftlint:disable:next file_types_order
extension ButtonsView {
	enum InitError {
		case emptyButtons
	}
}

extension ButtonsView.InitError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .emptyButtons:
			return "Specified buttons are empty"
		}
	}
}
