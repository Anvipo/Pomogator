//
//  ShadowParameters.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

// swiftlint:disable:next file_types_order
extension ShadowParameters {
	static var caDefault: Self {
		Self(
			color: UIColor.black.cgColor,
			offset: CGSize(width: 0, height: -3),
			opacity: 0,
			path: nil,
			radius: 3
		)
	}

	static func `default`(
		color: CGColor? = Self.caDefault.color,
		offset: CGSize = Self.caDefault.offset,
		opacity: Float = Self.caDefault.opacity,
		path: CGPath? = Self.caDefault.path,
		radius: CGFloat = Self.caDefault.radius
	) -> Self {
		Self(
			color: color,
			offset: offset,
			opacity: opacity,
			path: path,
			radius: radius
		)
	}
}

struct ShadowParameters {
	let color: CGColor?

	let offset: CGSize

	let opacity: Float

	let path: CGPath?

	let radius: CGFloat
}
