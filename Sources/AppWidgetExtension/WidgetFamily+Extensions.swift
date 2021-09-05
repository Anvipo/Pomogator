//
//  WidgetFamily+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 10.03.2023.
//

import WidgetKit

extension WidgetFamily {
	static var accessories: [Self] {
#if os(watchOS)
		[.accessoryRectangular, .accessoryInline, .accessoryCircular, .accessoryCorner]
#else
		[.accessoryRectangular, .accessoryInline, .accessoryCircular]
#endif
	}

	var isAccessory: Bool {
		switch self {
		case .accessoryCircular, .accessoryRectangular, .accessoryInline: true
		case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge: false
			// swiftlint:disable vertical_whitespace_between_cases
#if os(watchOS)
		case .accessoryCorner: true
#endif
			// swiftlint:enable vertical_whitespace_between_cases
		@unknown default: false
		}
	}
}
