//
//  CGFloat.PercentageCalculatingError.swift
//  Pomogator
//
//  Created by Anvipo on 25.09.2021.
//

import CoreGraphics
import Foundation

// swiftlint:disable:next file_types_order
extension CGFloat {
	enum PercentageCalculatingError {
		case invalidRange

		case rangeDoesNotContainSelf
	}
}

extension CGFloat.PercentageCalculatingError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .invalidRange:
			return "Range is invalid. Lower bound is greater than upper bound"

		case .rangeDoesNotContainSelf:
			return "Range does not contain self"
		}
	}
}
