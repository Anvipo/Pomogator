//
//  DateFieldView.swift
//  App
//
//  Created by Anvipo on 11.09.2021.
//

import UIKit

final class DateFieldView<ID: IDType>: TextFieldView<ID> {
	private let datePicker: UIDatePicker
	private var lastChosenDate: Date?
	private var item: DateFieldItem<ID>!

	init(item: DateFieldItem<ID>) {
		datePicker = UIDatePicker()

		super.init()

		setUpUI()
		configure(with: item)
	}

	// swiftlint:disable:next unused_parameter
	override func textField(_: UITextField, shouldChangeCharactersIn: NSRange, replacementString: String) -> Bool {
		false
	}
}

extension DateFieldView: UIContentView {
	var configuration: UIContentConfiguration {
		get {
			item
		}
		set {
			guard let newItem = newValue as? DateFieldItem<ID> else {
				assertionFailure("Неподдерживаемая конфигурация:\n\(newValue)")
				return
			}

			configure(with: newItem)
		}
	}

	func supports(_ configuration: UIContentConfiguration) -> Bool {
		configuration is DateFieldItem<ID>
	}
}

private extension DateFieldView {
	func setUpUI() {
		datePicker.add(
			action: { [weak self] in self?.datePickerValueChanged(in: $0) },
			for: .valueChanged
		)
		set(inputView: datePicker)
	}

	func configure(with item: DateFieldItem<ID>) {
		guard self.item != item else {
			return
		}

		self.item = item

		configure(with: item.textFieldItem)

		datePicker.calendar = item.calendar
		if let updatedDate = item.content.value {
			datePicker.date = updatedDate
		}
		datePicker.datePickerMode = item.datePickerMode

		datePicker.preferredDatePickerStyle = item.datePickerStyle
		datePicker.timeZone = item.calendar.timeZone

		datePicker.locale = item.calendar.locale
		datePicker.tintColor = item.datePickerTintColorStyle.color
		lastChosenDate = datePicker.date

		set(icon: item.content.icon)
		set(title: item.content.title)

		updateText()
	}

	func datePickerValueChanged(in datePicker: UIDatePicker) {
		guard let delegate = item.delegate else {
			assertionFailure("?")
			return
		}

		var newDate = datePicker.date

		if item.shouldEraseSeconds && datePicker.calendar.seconds(from: newDate) != 0 {
			if let editedNewDate = datePicker.calendar.dateBySettingZeroSecond(of: newDate) {
				newDate = editedNewDate
			} else {
				assertionFailure("?")
			}
		}

		let shouldChange = delegate.dateFieldItem(item, shouldChangeTo: newDate)

		if shouldChange {
			lastChosenDate = newDate
			item.content.value = newDate

			updateText()

			delegate.dateFieldItemDidChangeValue(item)
		} else if let lastChosenDate {
			datePicker.date = lastChosenDate
		} else {
			assertionFailure("?")
		}
	}

	func updateText() {
		guard let delegate = item.delegate else {
			assertionFailure("?")
			return
		}

		if let currentValue = item.content.value {
			let (text, accessibilityText) = delegate.dateFieldItem(item, format: currentValue)

			set(text: text, accessibilityText: accessibilityText)
		} else {
			set(text: "", accessibilityText: String(localized: "Text field accessibility empty value"))
		}
	}
}
