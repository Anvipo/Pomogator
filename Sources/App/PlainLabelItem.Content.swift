//
//  PlainLabelItem.Content.swift
//  App
//
//  Created by Anvipo on 06.03.2023.
//

extension PlainLabelItem {
	struct Content {
		let customAccessibilityLabel: String?
		let customAccessibilityValue: String?
		let text: String

		init(
			text: String,
			customAccessibilityLabel: String? = nil,
			customAccessibilityValue: String? = nil
		) {
			self.customAccessibilityLabel = customAccessibilityLabel
			self.customAccessibilityValue = customAccessibilityValue
			self.text = text
		}
	}
}
