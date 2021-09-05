//
//  StringFieldView.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class StringFieldView<ID: IDType>: TextFieldView<ID> {
	private var item: StringFieldItem<ID>!

	init(item: StringFieldItem<ID>) {
		super.init()

		configure(with: item)
	}

	override func textFieldDidChange(text: String) {
		guard let delegate = item.delegate else {
			assertionFailure("?")
			return
		}

		item.content.value = text

		let formattedText = delegate.stringFieldItemFormattedString(item)
		set(text: formattedText)
		item.content.value = formattedText

		delegate.stringFieldItemDidChangeValue(item)
	}

	override func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		guard let delegate = item.delegate else {
			assertionFailure("?")
			return true
		}

		let sourceText = textField.text ?? ""
		guard let stringRange = Range(range, in: sourceText) else {
			assertionFailure("?")
			return false
		}

		return delegate.stringFieldItem(
			item,
			shouldChangeCharactersIn: stringRange,
			replacementString: string
		)
	}
}

extension StringFieldView: UIContentView {
	var configuration: UIContentConfiguration {
		get {
			item
		}
		set {
			guard let newItem = newValue as? StringFieldItem<ID> else {
				assertionFailure("Неподдерживаемая конфигурация:\n\(configuration)")
				return
			}

			configure(with: newItem)
		}
	}

	func supports(_ configuration: UIContentConfiguration) -> Bool {
		configuration is StringFieldItem<ID>
	}
}

private extension StringFieldView {
	func configure(with item: StringFieldItem<ID>) {
		guard self.item != item else {
			return
		}

		self.item = item

		configure(with: item.textFieldItem)

		set(icon: item.content.icon)
		set(title: item.content.title)
		set(text: item.content.value)
		set(keyboardType: item.textKeyboardType)
	}
}
