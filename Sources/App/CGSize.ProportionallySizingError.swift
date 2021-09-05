//
//  CGSize.ProportionallySizingError.swift
//  Pomogator
//
//  Created by Anvipo on 25.09.2021.
//

import CoreGraphics
import Foundation

extension CGSize {
	enum ProportionallySizingError {
		case hasAtLeastOneZeroSide
	}
}

extension CGSize.ProportionallySizingError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .hasAtLeastOneZeroSide: "Size has at least one zero side"
		}
	}
}
