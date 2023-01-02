//
//  Color.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import UIKit

enum Color {
	case brand

	case black
	case white

	case tertiarySystemBackground

	case label
	case secondaryLabel
	case tertiaryLabel
	case labelOnBrand
}

extension Color {
	var uiColor: UIColor {
		switch self {
		case .brand:
			return UIColor(red: 0, green: 0.584, blue: 0.251, alpha: 1)

		case .black:
			return .black

		case .white:
			return .white

		case .tertiarySystemBackground:
			return .tertiarySystemBackground

		case .label:
			return .label

		case .secondaryLabel:
			return .secondaryLabel

		case .tertiaryLabel:
			return .tertiaryLabel

		case .labelOnBrand:
			return .white
		}
	}

	var highlightedUIColor: UIColor {
		let uiColor = uiColor
		switch self {
		case .brand:
			if let highlightedUIColor = uiColor.withBrightnessComponent(0.7) {
				return highlightedUIColor
			} else {
				assertionFailure("?")
				return uiColor
			}

		default:
			return uiColor
		}
	}
}
