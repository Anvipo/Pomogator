//
//  FontStyle.swift
//  App
//
//  Created by Anvipo on 12.09.2021.
//

import UIKit

enum FontStyle: Hashable {
	case subheadline
	case headline
	case title2
	case body
	case caption2
}

extension FontStyle {
	var fontMetrics: UIFontMetrics {
		UIFontMetrics(forTextStyle: uiKitAnalog)
	}

	var font: UIFont {
		.preferredFont(forTextStyle: uiKitAnalog)
	}

	var symbolConfiguration: UIImage.SymbolConfiguration {
		UIImage.SymbolConfiguration(font: font)
	}
}

private extension FontStyle {
	var uiKitAnalog: UIFont.TextStyle {
		switch self {
		case .title2: .title2
		case .headline: .headline
		case .subheadline: .subheadline
		case .body: .body
		case .caption2: .caption2
		}
	}
}
