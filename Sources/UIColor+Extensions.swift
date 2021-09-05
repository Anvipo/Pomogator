//
//  UIColor+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 05.01.2023.
//

import UIKit

extension UIColor {
	var hsbaComponents: HSBAComponents? {
		var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0

		guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
			assertionFailure("?")
			return nil
		}

		return HSBAComponents(
			hue: hue,
			saturation: saturation,
			brightness: brightness,
			alpha: alpha
		)
	}

	convenience init(hsbaComponents: HSBAComponents) {
		self.init(
			hue: hsbaComponents.hue,
			saturation: hsbaComponents.saturation,
			brightness: hsbaComponents.brightness,
			alpha: hsbaComponents.alpha
		)
	}

	func withBrightnessComponent(_ brightness: CGFloat) -> UIColor? {
		guard var hsbaComponents else {
			assertionFailure("?")
			return nil
		}

		hsbaComponents.brightness = brightness
		return UIColor(hsbaComponents: hsbaComponents)
	}
}
