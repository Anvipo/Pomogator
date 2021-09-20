//
//  PlainSpacerView.swift
//  Pomogator
//
//  Created by Anvipo on 12.12.2022.
//

import UIKit

final class PlainSpacerView<ID: IDType>: UIView {
	// swiftlint:disable:next implicitly_unwrapped_optional
	private var item: PlainSpacerItem<ID>!

	override var intrinsicContentSize: CGSize {
		sizeThatFits(.zero)
	}

	init(item: PlainSpacerItem<ID>) {
		super.init(frame: .zero)

		configure(with: item)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func sizeThatFits(_ size: CGSize) -> CGSize {
		switch item.type {
		case let .vertical(height):
			return CGSize(
				width: UIView.noIntrinsicMetric,
				height: height
			)

		case let .horizontal(width):
			return CGSize(
				width: width,
				height: UIView.noIntrinsicMetric
			)
		}
	}
}

extension PlainSpacerView: UIContentView {
	var configuration: UIContentConfiguration {
		get {
			item
		}
		set {
			guard let newItem = newValue as? PlainSpacerItem<ID> else {
				assertionFailure("Неподдерживаемая конфигурация:\n\(newValue)")
				return
			}

			configure(with: newItem)
		}
	}

	func supports(_ configuration: UIContentConfiguration) -> Bool {
		configuration is PlainSpacerItem<ID>
	}
}

private extension PlainSpacerView {
	func configure(with item: PlainSpacerItem<ID>) {
		guard self.item != item else {
			return
		}

		self.item = item
	}
}
