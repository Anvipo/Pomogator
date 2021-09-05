//
//  ButtonsView.InitError.swift
//  App
//
//  Created by Anvipo on 16.11.2021.
//

import Foundation

extension ButtonsView {
	enum InitError {
		case emptyButtons
	}
}

extension ButtonsView.InitError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .emptyButtons: "Specified buttons are empty"
		}
	}
}
