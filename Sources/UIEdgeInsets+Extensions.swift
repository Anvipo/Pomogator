//
//  UIEdgeInsets+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 08.01.2023.
//

import UIKit

extension UIEdgeInsets {
	static var `default`: Self {
		Self(
			top: .defaultVerticalOffset,
			left: .defaultHorizontalOffset,
			bottom: .defaultVerticalOffset,
			right: .defaultHorizontalOffset
		)
	}

	static func `default`(
		top: CGFloat = 0,
		bottom: CGFloat = 0
	) -> Self {
		Self(
			top: top,
			left: .defaultHorizontalOffset,
			bottom: bottom,
			right: .defaultHorizontalOffset
		)
	}

	static func `default`(verticalInset: CGFloat = 0) -> Self {
		Self(
			top: verticalInset,
			left: .defaultHorizontalOffset,
			bottom: verticalInset,
			right: .defaultHorizontalOffset
		)
	}
}

extension UIEdgeInsets {
	var inverted: Self {
		.init(top: -top, left: -left, bottom: -bottom, right: -right)
	}

	var vertical: CGFloat {
		top + bottom
	}

	var horizontal: CGFloat {
		left + right
	}

	init(
		horizontalInset: CGFloat,
		verticalInset: CGFloat
	) {
		self.init(
			top: verticalInset,
			left: horizontalInset,
			bottom: verticalInset,
			right: horizontalInset
		)
	}

	init(side: CGFloat) {
		self.init(
			top: side,
			left: side,
			bottom: side,
			right: side
		)
	}

	func copy(
		top: CGFloat? = nil,
		left: CGFloat? = nil,
		bottom: CGFloat? = nil,
		right: CGFloat? = nil
	) -> Self {
		Self(
			top: top ?? self.top,
			left: left ?? self.left,
			bottom: bottom ?? self.bottom,
			right: right ?? self.right
		)
	}
}

extension UIEdgeInsets: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(left, top, right, bottom)
	}
}
