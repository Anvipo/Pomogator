//
//  Button.FullConfiguration.swift
//  App
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit

extension Button {
	struct FullConfiguration {
		let accessibilityLabel: String?
		let adjustsImageSizeForAccessibilityContentSizeCategory: Bool
		let isPointerInteractionEnabled: Bool
		let uiConfiguration: UIButton.Configuration
		let uiConfigurationUpdateHandler: ((Button) -> Void)?
		var onTap: ((Button) -> Void)!
	}
}

extension Button.FullConfiguration: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.uiConfiguration == rhs.uiConfiguration
	}
}
