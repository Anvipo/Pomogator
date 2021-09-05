//
//  ColorStyle.swift
//  App
//
//  Created by Anvipo on 12.09.2021.
//

import UIKit

enum ColorStyle: Hashable {
	case clear

	case brand

	case tertiarySystemBackground

	case label
	case secondaryLabel
	case tertiaryLabel
	case labelOnBrand
}

extension ColorStyle {
	var color: UIColor {
		switch self {
		case .clear: .clear
		case .brand: .brand
		case .tertiarySystemBackground: .tertiarySystemBackground
		case .label: .label
		case .secondaryLabel: .secondaryLabel
		case .tertiaryLabel: .tertiaryLabel
		case .labelOnBrand: .white
		}
	}

	var highlightedColor: UIColor {
		let color = color
		switch self {
		case .brand:
			if let highlightedUIColor = color.withBrightnessComponent(0.7) {
				return highlightedUIColor
			}

			assertionFailure("?")
			return color

		default:
			return color
		}
	}
}
