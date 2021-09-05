//
//  Font.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import UIKit

enum Font {
	case largeTitle
	case title1
	case title2
	case title3
	case headline
	case subheadline
	case body
	case callout
	case footnote
	case caption1
	case caption2
}

extension Font {
	var uiFont: UIFont {
		switch self {
		case .largeTitle:
			return .preferredFont(forTextStyle: .largeTitle)

		case .title1:
			return .preferredFont(forTextStyle: .title1)

		case .title2:
			return .preferredFont(forTextStyle: .title2)

		case .title3:
			return .preferredFont(forTextStyle: .title3)

		case .headline:
			return .preferredFont(forTextStyle: .headline)

		case .subheadline:
			return .preferredFont(forTextStyle: .subheadline)

		case .body:
			return .preferredFont(forTextStyle: .body)

		case .callout:
			return .preferredFont(forTextStyle: .callout)

		case .footnote:
			return .preferredFont(forTextStyle: .footnote)

		case .caption1:
			return .preferredFont(forTextStyle: .caption1)

		case .caption2:
			return .preferredFont(forTextStyle: .caption2)
		}
	}
}
