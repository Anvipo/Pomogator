//
//  NSDirectionalEdgeInsets+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

extension NSDirectionalEdgeInsets {
	static var `default`: Self {
		Self(
			top: .defaultVerticalOffset,
			leading: .defaultHorizontalOffset,
			bottom: .defaultVerticalOffset,
			trailing: .defaultHorizontalOffset
		)
	}

	static func `default`(
		top: CGFloat = 0,
		bottom: CGFloat = 0
	) -> Self {
		Self(
			top: top,
			leading: .defaultHorizontalOffset,
			bottom: bottom,
			trailing: .defaultHorizontalOffset
		)
	}

	static func `default`(verticalInset: CGFloat = 0) -> Self {
		Self(
			top: verticalInset,
			leading: .defaultHorizontalOffset,
			bottom: verticalInset,
			trailing: .defaultHorizontalOffset
		)
	}
}

extension NSDirectionalEdgeInsets {
	var vertical: CGFloat {
		top + bottom
	}

	var horizontal: CGFloat {
		leading + trailing
	}

	init(
		horizontalInset: CGFloat,
		verticalInset: CGFloat = 0
	) {
		self.init(
			top: verticalInset,
			leading: horizontalInset,
			bottom: verticalInset,
			trailing: horizontalInset
		)
	}

	init(side: CGFloat) {
		self.init(
			top: side,
			leading: side,
			bottom: side,
			trailing: side
		)
	}

	func copy(
		top: CGFloat? = nil,
		leading: CGFloat? = nil,
		bottom: CGFloat? = nil,
		trailing: CGFloat? = nil
	) -> Self {
		Self(
			top: top ?? self.top,
			leading: leading ?? self.leading,
			bottom: bottom ?? self.bottom,
			trailing: trailing ?? self.trailing
		)
	}
}

extension NSDirectionalEdgeInsets: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(leading, top, trailing, bottom)
	}
}
