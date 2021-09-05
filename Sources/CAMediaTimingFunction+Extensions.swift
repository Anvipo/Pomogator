//
//  CAMediaTimingFunction+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 10.01.2023.
//

import QuartzCore

extension CAMediaTimingFunction {
	static var linear: Self {
		Self(name: .linear)
	}

	static var easeIn: Self {
		Self(name: .easeIn)
	}

	static var easeOut: Self {
		Self(name: .easeOut)
	}

	static var easeInEaseOut: Self {
		Self(name: .easeInEaseOut)
	}

	static var `default`: Self {
		Self(name: .`default`)
	}
}
