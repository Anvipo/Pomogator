//
//  TextFieldView.swift
//  App
//
//  Created by Anvipo on 12.03.2023.
//

import UIKit

class TextFieldView<ID: IDType>: FieldView<UITextField, ID>, UITextFieldDelegate {
	private var textFieldToolbar: UIToolbar?
	private var item: TextFieldItem<ID>!

	override init() {
		super.init()
		setUpUI()
	}

	override func traitPreferredContentSizeCategoryDidChange(_ previousTraitCollection: UITraitCollection) {
		super.traitPreferredContentSizeCategoryDidChange(previousTraitCollection)

		guard traitCollection.hasDifferentPreferredContentSizeCategory(comparedTo: previousTraitCollection) else {
			return
		}

		// UITextField сам не масштабирует шрифт, поможем ему))
		setUpUIBasedOnTraitCollection()
	}

	// swiftlint:disable unused_parameter
	func textFieldDidChange(text: String) {
		assertionFailure("Реализуй в наследнике")
	}

	func textField(_: UITextField, shouldChangeCharactersIn: NSRange, replacementString: String) -> Bool {
		assertionFailure("Реализуй в наследнике")
		return false
	}

	func textFieldShouldBeginEditing(_: UITextField) -> Bool {
		setUpTextFieldToolbarIfNeeded()
		return true
	}

	func textFieldDidBeginEditing(_: UITextField) {
		item.delegate?.textFieldItemDidBeginEditing(item)
		setUpStyle()
	}

	func textFieldDidEndEditing(_: UITextField, reason: UITextField.DidEndEditingReason) {
		item.delegate?.textFieldItemDidEndEditing(item)
		setUpStyle()
	}
	// swiftlint:enable unused_parameter
}

extension TextFieldView {
	func configure(with item: TextFieldItem<ID>) {
		configure(with: item.fieldItem)

		self.item = item

		contentView.adjustsFontForContentSizeCategory = item.textAdjustsFontForContentSizeCategory
		contentView.adjustsFontSizeToFitWidth = item.textAdjustsFontSizeToFitWidth
		contentView.borderStyle = item.textFieldBorderStyle
		contentView.placeholder = item.placeholder
		contentView.textColor = item.textColorStyle.color
		contentView.tintColor = item.textFieldTintColorStyle.color
		setUpUIBasedOnTraitCollection()
		contentView.configure(with: item.textFieldInputTraits)
	}
}

extension TextFieldView {
	func set(text: String, accessibilityText: String? = nil) {
		contentView.text = text
		contentView.accessibilityValue = obtainAccessibilityText(from: accessibilityText ?? text)
	}

	func set(keyboardType: UIKeyboardType) {
		contentView.keyboardType = keyboardType
	}

	func set(inputView: UIView) {
		contentView.inputView = inputView
	}
}

private extension TextFieldView {
	func obtainAccessibilityText(from possibleAccessibilityText: String) -> String {
		possibleAccessibilityText.isEmpty
		? String(localized: "Text field accessibility empty value")
		: possibleAccessibilityText
	}

	// фикс layout warning-ов toolbar-а
	func setUpTextFieldToolbarIfNeeded() {
		guard let toolbarItems = item.toolbarItems.nonEmptyOrNil else {
			textFieldToolbar = nil
			return
		}

		guard textFieldToolbar == nil else {
			return
		}

		guard let window else {
			assertionFailure("?")
			return
		}

		let textFieldToolbar = UIToolbar(
			frame: CGRect(
				origin: .zero,
				size: CGSize(
					// ширина самой field view не подходит, т.к. на iPad клавиатура по всей ширине экрана
					// поэтому берём ширину окна
					width: window.frame.width,
					// sizeToFit() подправит до нужной высоты
					height: .greatestFiniteMagnitude
				)
			)
		)

		textFieldToolbar.items = toolbarItems
		textFieldToolbar.tintColor = item.toolbarTintColorStyle.color

		contentView.inputAccessoryView = textFieldToolbar

		if textFieldToolbar.items?.isNotEmpty == true {
			textFieldToolbar.sizeToFit()
		}

		self.textFieldToolbar = textFieldToolbar
	}

	func setUpUI() {
		contentView.add(
			action: { [weak self] in self?.textFieldDidChange($0) },
			for: .editingChanged
		)
		contentView.delegate = self
	}

	func textFieldDidChange(_ textField: UITextField) {
		textFieldDidChange(text: textField.text ?? "")
	}

	func setUpUIBasedOnTraitCollection() {
		contentView.font = item.textFontStyle.font
	}
}
