//
//  CGPoint+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

import CoreGraphics

extension CGPoint {
	var distance: CGFloat {
		sqrt(pow(x, 2) + pow(y, 2))
	}

	var rounded: Self {
		Self(x: ceil(x), y: ceil(y))
	}

	func scaled(ratio: CGFloat) -> Self {
		Self(x: x * ratio, y: y * ratio)
	}

	func shifted(by point: Self) -> Self {
		Self(x: x + point.x, y: y + point.y)
	}
}
