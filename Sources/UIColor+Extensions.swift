//
//  UIColor+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 05.01.2023.
//

import UIKit

extension UIColor {
	/// Смешивает 2 цвета с определенным соотношением
	static func blend(color1: UIColor, color2: UIColor, progress: CGFloat) -> UIColor? {
		if progress >= 1 {
			return color2
		}

		if progress <= 0 {
			return color1
		}

		let p1 = 1 - progress
		let p2 = progress

		guard let color1RGBAComponents = color1.rgbaComponents,
			  let color2RGBAComponents = color2.rgbaComponents
		else {
			return nil
		}

		return Self(
			red: p1 * color1RGBAComponents.red + p2 * color2RGBAComponents.red,
			green: p1 * color1RGBAComponents.green + p2 * color2RGBAComponents.green,
			blue: p1 * color1RGBAComponents.blue + p2 * color2RGBAComponents.blue,
			alpha: p1 * color1RGBAComponents.alpha + 2 * color2RGBAComponents.alpha
		)
	}

	static func interpolate(from fromColor: UIColor, to toColor: UIColor, percent: CGFloat) -> UIColor? {
		guard let fromColorRGBAComponents = fromColor.rgbaComponents,
			  let toColorRGBAComponents = toColor.rgbaComponents
		else {
			return nil
		}

		let resultRed = fromColorRGBAComponents.red + percent * (toColorRGBAComponents.red - fromColorRGBAComponents.red)
		let resultGreen = fromColorRGBAComponents.green + percent * (toColorRGBAComponents.green - fromColorRGBAComponents.green)
		let resultBlue = fromColorRGBAComponents.blue + percent * (toColorRGBAComponents.blue - fromColorRGBAComponents.blue)

		return UIColor(red: resultRed, green: resultGreen, blue: resultBlue, alpha: 1)
	}
}

extension UIColor {
	var rgbaComponents: RGBAComponents? {
		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0

		guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
			return nil
		}

		return RGBAComponents(red: red, green: green, blue: blue, alpha: alpha)
	}

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

	convenience init(rgbaComponents: RGBAComponents) {
		self.init(
			red: rgbaComponents.red,
			green: rgbaComponents.green,
			blue: rgbaComponents.blue,
			alpha: rgbaComponents.alpha
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
}

extension UIColor {
	var hexString: String? {
		guard let rgbaComponents else {
			return nil
		}

		return String(
			format: "#%02lx%02lx%02lx",
			Int(rgbaComponents.red * 255),
			Int(rgbaComponents.green * 255),
			Int(rgbaComponents.blue * 255)
		)
	}

	var hexWithAlphaString: String? {
		guard let rgbaComponents else {
			return nil
		}

		return String(
			format: "#%02lx%02lx%02lx%02lx",
			Int(rgbaComponents.alpha * 255),
			Int(rgbaComponents.red * 255),
			Int(rgbaComponents.green * 255),
			Int(rgbaComponents.blue * 255)
		)
	}

	convenience init?(hexString: String) {
		guard let hexValue = UInt64(hexString: hexString) else {
			return nil
		}

		self.init(hexValue: hexValue, alpha: 1)
	}

	convenience init?(hexWithAlphaString: String) {
		guard let hexWithAlphaValue = UInt64(hexString: hexWithAlphaString) else {
			return nil
		}

		self.init(hexWithAlphaValue: hexWithAlphaValue)
	}

	convenience init(hexValue: UInt32, alpha: CGFloat) {
		self.init(hexValue: UInt64(hexValue), alpha: alpha)
	}

	convenience init(hexWithAlphaValue: UInt32) {
		self.init(hexWithAlphaValue: UInt64(hexWithAlphaValue))
	}

	convenience init(hexValue: UInt64, alpha: CGFloat) {
		let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255
		let green = CGFloat((hexValue & 0xFF00) >> 8) / 255
		let blue = CGFloat(hexValue & 0xFF) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}

	convenience init(hexWithAlphaValue: UInt64) {
		let red = CGFloat((hexWithAlphaValue & 0xFF0000) >> 16) / 255
		let green = CGFloat((hexWithAlphaValue & 0xFF00) >> 8) / 255
		let blue = CGFloat((hexWithAlphaValue & 0xFF)) / 255
		let alpha = CGFloat(hexWithAlphaValue >> 24) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
}

extension UIColor {
	/// Оттенок серого для данного цвета
	var grayscaled: UIColor? {
		withSaturationComponent(0)
	}

	func withSaturationComponent(_ saturation: CGFloat) -> UIColor? {
		guard var hsbaComponents else {
			assertionFailure("?")
			return nil
		}

		hsbaComponents.saturation = saturation
		return UIColor(hsbaComponents: hsbaComponents)
	}
}

extension UIColor {
	/// Светлый ли цвет
	///
	/// * [W3C color contrast](https://www.w3.org/WAI/ER/WD-AERT/#color-contrast)
	/// * [Stack overflow](https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright)
	var isBright: Bool {
		guard let rgbaComponents else {
			assertionFailure("?")
			return false
		}

		let brightness = ((rgbaComponents.red * 299) + (rgbaComponents.green * 587) + (rgbaComponents.blue * 114)) / 1_000
		return brightness >= 0.75
	}

	func withBrightnessComponent(_ brightness: CGFloat) -> UIColor? {
		guard var hsbaComponents else {
			assertionFailure("?")
			return nil
		}

		hsbaComponents.brightness = brightness
		return UIColor(hsbaComponents: hsbaComponents)
	}

	/// Возвращает новый цвет с измененным на заданное значение brightness
	func color(brightnessDiff: CGFloat) -> UIColor? {
		guard let hsbaComponents else {
			assertionFailure("?")
			return nil
		}

		let newBrightness = max(min((hsbaComponents.brightness + brightnessDiff / 255), 1), 0)

		return withBrightnessComponent(newBrightness)
	}

	/// Возвращает цвета для градиента, созданные из одного цвета с определённым brightness
	func gradientColors(brightness: CGFloat = 10) -> [UIColor] {
		guard let startColor = color(brightnessDiff: -brightness),
			  let endColor = color(brightnessDiff: brightness)
		else {
			assertionFailure("?")
			return []
		}

		return [startColor, endColor]
	}
}
