//
//  Button.swift
//  App
//
//  Created by Anvipo on 30.08.2021.
//

import UIKit

class Button: UIButton {
	private let convenientHitAreaCalculator: ConvenientHitAreaCalculator

	var fullConfiguration: FullConfiguration?

	init(fullConfiguration: FullConfiguration?) {
		convenientHitAreaCalculator = ConvenientHitAreaCalculator()

		super.init(frame: .zero)

		convenientHitAreaCalculator.view = self

		if let fullConfiguration {
			configure(with: fullConfiguration)
		}

		add(
			action: { [weak self] button in
				self?.fullConfiguration?.onTap(button)
			},
			for: .touchUpInside
		)

		configurationUpdateHandler = { [weak self] button in
			guard let button = button as? Self else {
				assertionFailure("?")
				return
			}

			guard let uiConfigurationUpdateHandler = self?.fullConfiguration?.uiConfigurationUpdateHandler else {
				return
			}

			uiConfigurationUpdateHandler(button)
		}
	}

	// swiftlint:disable unused_parameter
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// swiftlint:enable unused_parameter

	override final func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		convenientHitAreaCalculator.point(
			inside: point,
			with: event,
			superImplementation: super.point(inside:with:)
		)
	}
}

extension Button {
	func configure(with fullConfiguration: FullConfiguration) {
		guard self.fullConfiguration != fullConfiguration else {
			return
		}

		self.fullConfiguration = fullConfiguration

		configuration = fullConfiguration.uiConfiguration

		isPointerInteractionEnabled = fullConfiguration.isPointerInteractionEnabled
		imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = fullConfiguration.adjustsImageSizeForAccessibilityContentSizeCategory

		accessibilityLabel = fullConfiguration.accessibilityLabel
	}
}
