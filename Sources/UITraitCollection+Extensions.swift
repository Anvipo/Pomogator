//
//  UITraitCollection+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 10.01.2023.
//

import UIKit

extension UITraitCollection {
	var isLightModeEnabled: Bool {
		userInterfaceStyle == .light
	}

	var isDarkModeEnabled: Bool {
		userInterfaceStyle == .dark
	}
}
