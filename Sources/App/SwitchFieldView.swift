//
//  SwitchFieldView.swift
//  App
//
//  Created by Anvipo on 12.03.2023.
//

import UIKit

final class SwitchFieldView<ID: IDType>: FieldView<UISwitch, ID> {
	private var item: SwitchFieldItem<ID>!

	override var accessibilityContentText: String {
		contentView.isOn
		? String(localized: "Should autodelete schedule field view accessibility true value")
		: String(localized: "Should autodelete schedule field view accessibility false value")
	}

	init(item: SwitchFieldItem<ID>) {
		super.init()

		setUpUI()
		configure(with: item)
	}
}

extension SwitchFieldView: UIContentView {
	var configuration: UIContentConfiguration {
		get {
			item
		}
		set {
			guard let newItem = newValue as? SwitchFieldItem<ID> else {
				assertionFailure("Неподдерживаемая конфигурация:\n\(newValue)")
				return
			}

			configure(with: newItem)
		}
	}

	func supports(_ configuration: UIContentConfiguration) -> Bool {
		configuration is SwitchFieldItem<ID>
	}
}

private extension SwitchFieldView {
	func setUpUI() {
		contentView.add(
			action: { [weak self] in self?.switchValueChanged(in: $0) },
			for: .valueChanged
		)
	}

	func switchValueChanged(in switchView: UISwitch) {
		guard let delegate = item.delegate else {
			assertionFailure("?")
			return
		}

		item.content.value = switchView.isOn

		delegate.switchFieldItemDidChangeValue(item)
	}

	func configure(with item: SwitchFieldItem<ID>) {
		guard self.item != item else {
			return
		}

		self.item = item

		configure(with: item.fieldItem)

		set(icon: item.content.icon)
		set(title: item.content.title)

		contentView.setOn(item.content.value, animated: shouldAnimate)
		contentView.onTintColor = item.onTintColorStyle.color
		contentView.thumbTintColor = item.thumbTintColorStyle.color

		item.switchProvider.provider = { [weak self] in
			guard let self else {
				assertionFailure("?")
				return nil
			}

			return contentView
		}
	}
}
