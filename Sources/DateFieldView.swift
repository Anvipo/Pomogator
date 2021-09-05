//
//  DateFieldView.swift
//  Pomogator
//
//  Created by Anvipo on 11.09.2021.
//

import UIKit

final class DateFieldView<ID: Hashable>: FieldView<ID> {
	private let datePicker: UIDatePicker
	private var lastChosenDate: Date?
	// swiftlint:disable:next implicitly_unwrapped_optional
	private var item: DateFieldItem<ID>!

	init(item: DateFieldItem<ID>) {
		datePicker = UIDatePicker()

		super.init(frame: .zero)

		setupUI()
		configure(with: item)
	}

	@objc
	private func datePickerValueChanged(in datePicker: UIDatePicker) {
		var newDate = datePicker.date
		let newDateComponents = datePicker.calendar.dateComponents([.hour, .minute, .second], from: newDate)

		if item.shouldEraseSeconds && newDateComponents.second != 0 {
			if let editedNewDate = datePicker.calendar.date(
				// swiftlint:disable force_unwrapping
				bySettingHour: newDateComponents.hour!,
				minute: newDateComponents.minute!,
				// swiftlint:enable force_unwrapping
				second: 0,
				of: newDate,
				matchingPolicy: .strict
			) {
				newDate = editedNewDate
			} else {
				assertionFailure("?")
			}
		}

		let shouldChange = item.delegate?.dateFieldItem(
			item,
			shouldChangeTo: newDate
		) ?? true

		if shouldChange {
			lastChosenDate = newDate
			item.content.date = newDate
			set(text: item.getDateText(newDate))
			item.delegate?.dateFieldItemDidChangeDate(item)
		} else if let lastChosenDate {
			datePicker.date = lastChosenDate
		} else {
			assertionFailure("?")
		}
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

extension DateFieldView {
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		false
	}
}

private extension DateFieldView {
	func setupUI() {
		datePicker.addTarget(
			self,
			action: #selector(datePickerValueChanged(in:)),
			for: .valueChanged
		)
		set(inputView: datePicker)
	}

	func configure(with item: DateFieldItem<ID>) {
		guard self.item != item else {
			return
		}

		self.item = item

		baseConfigure(with: item.fieldItem)

		datePicker.calendar = item.calendar
		if let updatedDate = item.content.date {
			datePicker.date = updatedDate
		}
		datePicker.datePickerMode = item.datePickerMode
		// попытка пофиксить UITableViewAlertForLayoutOutsideViewHierarchy
		if datePicker.isVisible {
			datePicker.preferredDatePickerStyle = item.datePickerStyle
			datePicker.timeZone = item.calendar.timeZone
		} else {
			UIView.performWithoutAnimation {
				datePicker.timeZone = item.calendar.timeZone
				datePicker.preferredDatePickerStyle = item.datePickerStyle
			}
		}
		datePicker.locale = item.calendar.locale
		datePicker.tintColor = item.datePickerTintColor
		lastChosenDate = datePicker.date

		set(icon: item.content.icon)
		set(title: item.content.title)
		if let updatedDate = item.content.date {
			set(text: item.getDateText(updatedDate))
		} else {
			set(text: "")
		}
	}
}
