//
//  FieldView.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

import UIKit

class FieldView<ID: IDType>: UIView, UITextFieldDelegate {
	private let textFieldToolbar: UIToolbar
	private let commonStackView: UIStackView
	private let iconImageView: UIImageView
	private let titleLabel: UILabel
	private let textField: UITextField
	private let textViewsStackView: UIStackView

	private var commonStackViewConstraints: [NSLayoutConstraint]
	private var commonStackViewInsets: NSDirectionalEdgeInsets
	// swiftlint:disable:next implicitly_unwrapped_optional
	private var item: FieldItem<ID>!

	override init(frame: CGRect) {
		textFieldToolbar = UIToolbar()
		iconImageView = UIImageView()
		titleLabel = UILabel()
		textField = UITextField()
		textViewsStackView = UIStackView(arrangedSubviews: [titleLabel, textField])

		commonStackView = UIStackView(arrangedSubviews: [iconImageView, textViewsStackView])

		commonStackViewConstraints = []
		commonStackViewInsets = .zero

		super.init(frame: frame)

		setupUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if self.point(inside: point, with: event) {
			// перенаправляем нажатия на textField
			return textField
		} else {
			return nil
		}
	}

	func textFieldDidChange(text: String) {
		assertionFailure("Реализуй в наследнике")
	}

	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		assertionFailure("Реализуй в наследнике")
		return false
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		item.delegate?.fieldItemDidBeginEditing(item)
		setupStyle()
	}

	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		item.delegate?.fieldItemDidEndEditing(item)
		setupStyle()
	}

	@objc
	private func textFieldDidChange(_ textField: UITextField) {
		textFieldDidChange(text: textField.text ?? "")
	}
}

extension FieldView {
	func baseConfigure(with item: FieldItem<ID>) {
		self.item = item

		backgroundColor = item.backgroundColor
		tintColor = item.tintColor

		textFieldToolbar.items = item.toolbarItems.isEmpty ? nil : item.toolbarItems
		textFieldToolbar.tintColor = item.toolbarTintColor
		if textFieldToolbar.items != nil {
			textFieldToolbar.sizeToFit()
		}

		iconImageView.tintColor = item.tintColor

		titleLabel.font = item.titleFont
		titleLabel.numberOfLines = item.titleNumberOfLines
		titleLabel.textColor = item.titleColor
		titleLabel.tintColor = item.titleTintColor

		textField.borderStyle = item.textFieldBorderStyle
		textField.font = item.textFont
		textField.textColor = item.textColor
		textField.tintColor = item.textFieldTintColor

		item.currentResponderProvider.currentResponder = textField

		setupStyle()

		let newStackViewInsets = item.contentInsets

		if commonStackViewConstraints.isEmpty || newStackViewInsets != commonStackViewInsets {
			commonStackViewInsets = newStackViewInsets
			NSLayoutConstraint.deactivate(commonStackViewConstraints)
			commonStackViewConstraints = commonStackView.makeSameAnchorConstraints(
				to: self,
				info: .edgesEqual(insets: commonStackViewInsets)
			)
			NSLayoutConstraint.activate(commonStackViewConstraints)
		}
	}
}

extension FieldView {
	func set(icon: UIImage) {
		var icon = icon
		if let iconTintColor = item.iconTintColor {
			icon = icon.withTintColor(iconTintColor)
		}
		iconImageView.image = icon
	}

	func set(title: String) {
		titleLabel.text = title
	}

	func set(text: String) {
		textField.text = text
	}

	func set(keyboardType: UIKeyboardType) {
		textField.keyboardType = keyboardType
	}

	func set(inputView: UIView) {
		textField.inputView = inputView
	}
}

private extension FieldView {
	func setupStyle() {
		animateIfNeeded { [weak self] in
			guard let self else {
				return
			}

			if self.textField.isFirstResponder {
				self.titleLabel.textColor = Color.brand.uiColor
				self.backgroundColor = Color.brand.uiColor.withAlphaComponent(0.1)
			} else {
				self.titleLabel.textColor = self.item.titleColor
				self.backgroundColor = nil
			}
		}
	}

	func setupUI() {
		commonStackView.spacing = .defaultHorizontalOffset
		commonStackView.alignment = .center

		iconImageView.contentMode = .scaleAspectFit

		NSLayoutConstraint.activate(iconImageView.makeEqualSidesConstraints(side: 30))

		textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		textField.delegate = self
		textField.inputAccessoryView = textFieldToolbar

		textViewsStackView.axis = .vertical
		textViewsStackView.spacing = 4

		addSubviewForConstraintsUse(commonStackView)
	}
}
