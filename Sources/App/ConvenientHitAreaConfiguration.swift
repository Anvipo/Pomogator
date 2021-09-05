//
//  ConvenientHitAreaConfiguration.swift
//  App
//
//  Created by Anvipo on 10.01.2023.
//

import CoreGraphics

struct ConvenientHitAreaConfiguration: Equatable {
	var convenientHitSize: CGSize
}

extension ConvenientHitAreaConfiguration {
	static var `default`: Self {
		Self(convenientHitSize: CGSize(side: 44))
	}
}
