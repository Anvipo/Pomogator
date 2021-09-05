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

extension NSDirectionalEdgeInsets: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(leading, top, trailing, bottom)
	}
}
