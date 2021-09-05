//
//  DateFieldItem.swift
//  App
//
//  Created by Anvipo on 11.09.2021.
//

import UIKit

struct DateFieldItem<ID: IDType> {
	let calendar: Calendar
	var content: Content
	let datePickerMode: UIDatePicker.Mode
	let datePickerStyle: UIDatePickerStyle
	let datePickerTintColorStyle: ColorStyle
	weak var delegate: IDateFieldItemDelegate?
	var textFieldItem: TextFieldItem<ID>
	let shouldEraseSeconds: Bool
}

extension DateFieldItem: IReuseIdentifiable {
	static var reuseID: String {
		"DateFieldItem"
	}
}

extension DateFieldItem: ITableViewItem {
	func update(tableViewCell: UITableViewCell) {
		tableViewCell.contentConfiguration = self
	}
}

extension DateFieldItem: UIContentConfiguration {
	func makeContentView() -> UIView & UIContentView {
		DateFieldView(item: self)
	}

	// swiftlint:disable:next unused_parameter
	func updated(for: UIConfigurationState) -> Self {
		self
	}
}

extension DateFieldItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.calendar == rhs.calendar &&
		lhs.content == rhs.content &&
		lhs.datePickerMode == rhs.datePickerMode &&
		lhs.datePickerStyle == rhs.datePickerStyle &&
		lhs.datePickerTintColorStyle == rhs.datePickerTintColorStyle &&
		lhs.delegate === rhs.delegate &&
		lhs.textFieldItem == rhs.textFieldItem &&
		lhs.shouldEraseSeconds == rhs.shouldEraseSeconds
	}
}

extension DateFieldItem: IItem {}

extension DateFieldItem: IFieldItemContainer {}

extension DateFieldItem: ITextFieldItemContainer {}
