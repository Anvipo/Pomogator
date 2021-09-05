//
//  ConvenientHitAreaConfiguration.swift
//  Pomogator
//
//  Created by Anvipo on 10.01.2023.
//

import CoreGraphics

// swiftlint:disable:next file_types_order
extension ConvenientHitAreaConfiguration {
	static var `default`: Self {
		Self(convenientHitSize: CGSize(side: 44))
	}
}

struct ConvenientHitAreaConfiguration: Equatable, Sendable {
	var convenientHitSize: CGSize
}
