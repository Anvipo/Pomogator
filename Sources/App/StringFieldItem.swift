//
//  StringFieldItem.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

struct StringFieldItem<ID: IDType> {
	var content: Content
	weak var delegate: IStringFieldItemDelegate?
	var textFieldItem: TextFieldItem<ID>
	let textKeyboardType: UIKeyboardType
}

extension StringFieldItem: IReuseIdentifiable {
	static var reuseID: String {
		"StringFieldItem"
	}
}

extension StringFieldItem: ITableViewItem {
	func update(tableViewCell: UITableViewCell) {
		tableViewCell.contentConfiguration = self
	}
}

extension StringFieldItem: UIContentConfiguration {
	func makeContentView() -> UIView & UIContentView {
		StringFieldView(item: self)
	}

	// swiftlint:disable:next unused_parameter
	func updated(for: UIConfigurationState) -> Self {
		self
	}
}

extension StringFieldItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.content == rhs.content &&
		lhs.delegate === rhs.delegate &&
		lhs.textFieldItem == rhs.textFieldItem &&
		lhs.textKeyboardType == rhs.textKeyboardType
	}
}

extension StringFieldItem: IItem {}

extension StringFieldItem: IFieldItemContainer {}

extension StringFieldItem: ITextFieldItemContainer {}
