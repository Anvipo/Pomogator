//
//  Button.FullConfiguration.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//
// swiftlint:disable file_types_order

import UIKit

extension Button {
	struct FullConfiguration {
		let uiConfiguration: UIButton.Configuration
		let uiConfigurationUpdateHandler: ((Button) -> Void)?
		let onTap: (Button) -> Void
	}
}

extension Button.FullConfiguration: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.uiConfiguration == rhs.uiConfiguration
	}
}
