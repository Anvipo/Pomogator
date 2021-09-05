//
//  CACornerMask+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 30.08.2021.
//

import QuartzCore

extension CACornerMask {
	static var all: Self {
		[
			.layerMinXMinYCorner,
			.layerMinXMaxYCorner,
			.layerMaxXMinYCorner,
			.layerMaxXMaxYCorner
		]
	}
}

extension CACornerMask: CaseIterable {
	public typealias AllCases = [Self]

	public static var allCases: AllCases {
		[
			.layerMinXMinYCorner,
			.layerMinXMaxYCorner,
			.layerMaxXMinYCorner,
			.layerMaxXMaxYCorner
		]
	}
}

extension CACornerMask: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(rawValue)
	}
}
