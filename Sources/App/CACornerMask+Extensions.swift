//
//  CACornerMask+Extensions.swift
//  App
//
//  Created by Anvipo on 30.08.2021.
//

import QuartzCore

extension CACornerMask: @retroactive CaseIterable {
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

extension CACornerMask: @retroactive Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(rawValue)
	}
}
