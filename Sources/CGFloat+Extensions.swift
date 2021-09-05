//
//  CGFloat+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import CoreGraphics

// MARK: - Constants

extension CGFloat {
	static var defaultVerticalOffset: Self {
		8
	}

	static var defaultHorizontalOffset: Self {
		16
	}

	static var disabledAlpha: Self {
		0.2
	}

	static var highlightedAlpha: Self {
		0.8
	}
}

// MARK: - Percentage extensions

extension CGFloat {
	func percentage(in range: ClosedRange<Self>) throws -> Self {
		if range.lowerBound >= range.upperBound {
			let error = PercentageCalculatingError.invalidRange
			assertionFailure(error.localizedDescription)
			throw error
		}

		if !range.contains(self) {
			let error = PercentageCalculatingError.rangeDoesNotContainSelf
			assertionFailure(error.localizedDescription)
			throw error
		}

		return (self - range.lowerBound) / (range.upperBound - range.lowerBound)
	}

	func reversedPercentage(in range: ClosedRange<Self>) throws -> Self {
		let percentage = try percentage(in: range)

		return 1 - percentage
	}
}
