//
//  PlainButtonView.swift
//  Pomogator
//
//  Created by Anvipo on 22.09.2021.
//

import UIKit

final class PlainButtonView<ID: IDType>: UIView {
	private let stackView: UIStackView
	private let button: Button
	private let accessoryButton: Button

	// swiftlint:disable:next implicitly_unwrapped_optional
	private var item: PlainButtonItem<ID>!

	init(item: PlainButtonItem<ID>) {
		button = Button(fullConfiguration: item.buttonFullConfiguration)
		accessoryButton = Button(fullConfiguration: item.accessoryButtonFullConfiguration)

		stackView = UIStackView(arrangedSubviews: [button, accessoryButton])

		super.init(frame: .zero)

		setupUI()
		configure(with: item)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension PlainButtonView: UIContentView {
	var configuration: UIContentConfiguration {
		get {
			item
		}
		set {
			guard let newItem = newValue as? PlainButtonItem<ID> else {
				assertionFailure("Неподдерживаемая конфигурация:\n\(newValue)")
				return
			}

			configure(with: newItem)
		}
	}

	func supports(_ configuration: UIContentConfiguration) -> Bool {
		configuration is PlainButtonItem<ID>
	}
}

private extension PlainButtonView {
	func setupUI() {
		backgroundColor = .clear

		accessoryButton.setContentHuggingPriority(.required, for: .horizontal)
		accessoryButton.setContentHuggingPriority(.required, for: .vertical)

		stackView.spacing = .defaultHorizontalOffset
		stackView.alignment = .center

		addSubviewForConstraintsUse(stackView)
		NSLayoutConstraint.activate(
			stackView.makeSameAnchorConstraints(
				to: self,
				info: .edgesEqual()
			)
		)
	}

	func configure(with item: PlainButtonItem<ID>) {
		guard self.item != item else {
			return
		}

		self.item = item

		button.configure(with: item.buttonFullConfiguration)

		accessoryButton.isHidden = item.accessoryButtonFullConfiguration == nil
		if let accessoryButtonFullConfiguration = item.accessoryButtonFullConfiguration {
			accessoryButton.configure(with: accessoryButtonFullConfiguration)
		}
	}
}
