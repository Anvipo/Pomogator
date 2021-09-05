//
//  BlurredView.SetBlurPercentageError.swift
//  Pomogator
//
//  Created by Anvipo on 25.09.2021.
//

import CoreGraphics
import Foundation

// swiftlint:disable:next file_types_order
extension BlurredView {
	enum SetBlurPercentageError {
		case wrongBlurPercentageValue(CGFloat)
	}
}

extension BlurredView.SetBlurPercentageError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case let .wrongBlurPercentageValue(value):
			return "\(value) should be in (0...1)"
		}
	}
}
