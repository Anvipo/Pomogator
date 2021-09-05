//
//  Button.FullConfiguration.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit

// swiftlint:disable:next file_types_order
extension Button {
	struct FullConfiguration {
		let uiConfiguration: UIButton.Configuration
		let uiConfigurationUpdateHandler: (@MainActor (Button) -> Void)?
		let onTap: (Button) -> Void
	}
}

extension Button.FullConfiguration: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.uiConfiguration == rhs.uiConfiguration
	}
}
