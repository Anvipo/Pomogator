//
//  Int+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

extension Int {
	var degreesToRadians: Double {
		Double(self) * .pi / 180
	}

	var radiansToDegrees: Double {
		Double(self) * 180 / .pi
	}
}
