//
//  PlainLabelHeaderItem.Content.swift
//  App
//
//  Created by Anvipo on 05.03.2023.
//

extension PlainLabelHeaderItem {
	struct Content {
		let accessibilityLabel: String
		let text: String
	}
}

extension PlainLabelHeaderItem.Content {
	init(sectionHeaderText: String) {
		accessibilityLabel = String(localized: "Section header accessibility text \(sectionHeaderText)")
		text = sectionHeaderText
	}
}
