//
//  CGSize.ProportionallySizingError.swift
//  Pomogator
//
//  Created by Anvipo on 25.09.2021.
//

import CoreGraphics
import Foundation

// swiftlint:disable:next file_types_order
extension CGSize {
	enum ProportionallySizingError {
		case hasAtLeastOneZeroSide
	}
}

extension CGSize.ProportionallySizingError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .hasAtLeastOneZeroSide:
			return "Size has at least one zero side"
		}
	}
}
