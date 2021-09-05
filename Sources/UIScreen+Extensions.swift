//
//  UIScreen+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 23.12.2022.
//

import UIKit

extension UIScreen {
	var isForceTouchAvailable: Bool {
		traitCollection.forceTouchCapability == .available
	}

	var screenResolutionString: String {
		switch scale {
		case 1:
			return "mdpi"

		case 2:
			return "xhdpi"

		case 3:
			return "xxhdpi"

		default:
			assertionFailure("?")
			return ""
		}
	}

	var isInLandscapeOrientation: Bool {
		bounds.width > bounds.height
	}
}
