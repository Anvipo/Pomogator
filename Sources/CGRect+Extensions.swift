//
//  CGRect+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

import CoreGraphics

extension CGRect {
	func scaled(ratio: CGFloat) -> Self {
		Self(origin: origin.scaled(ratio: ratio), size: size.scaled(ratio: ratio))
	}

	/// Возвращает отцентрированный rect заданного размера
	func center(size: CGSize) -> Self {
		let newOrigin = CGPoint(
			x: (width - size.width) * 0.5 + origin.x,
			y: (height - size.height) * 0.5 + origin.y
		)

		return Self(origin: newOrigin, size: size)
	}
}
