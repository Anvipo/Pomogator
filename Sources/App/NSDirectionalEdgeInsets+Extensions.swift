//
//  NSDirectionalEdgeInsets+Extensions.swift
//  App
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

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

	init(all: CGFloat) {
		self.init(top: all, leading: all, bottom: all, trailing: all)
	}
}

extension NSDirectionalEdgeInsets: @retroactive Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(leading, top, trailing, bottom)
	}
}
