//
//  WidgetFont.swift
//  AppWidgetExtension
//
//  Created by Anvipo on 10.03.2023.
//

import SwiftUI

enum WidgetFont {
	case headline
	case title
	case body
	case caption
}

extension WidgetFont {
	var font: Font {
		switch self {
		case .headline: .headline
		case .title: .title
		case .body: .body
		case .caption: .caption
		}
	}
}
