//
//  SwitchFieldItem.swift
//  App
//
//  Created by Anvipo on 12.03.2023.
//

import UIKit

struct SwitchFieldItem<ID: IDType> {
	var content: Content
	weak var delegate: ISwitchFieldItemDelegate?
	private(set) var fieldItem: FieldItem<ID>
	let onTintColorStyle: ColorStyle
	let switchProvider: SwitchFieldItemSwitchProvider
	let thumbTintColorStyle: ColorStyle
}

extension SwitchFieldItem: IReuseIdentifiable {
	static var reuseID: String {
		"SwitchFieldItem"
	}
}

extension SwitchFieldItem: ITableViewItem {
	func update(tableViewCell: UITableViewCell) {
		tableViewCell.contentConfiguration = self
	}
}

extension SwitchFieldItem: UIContentConfiguration {
	func makeContentView() -> UIView & UIContentView {
		SwitchFieldView(item: self)
	}

	// swiftlint:disable:next unused_parameter
	func updated(for: UIConfigurationState) -> Self {
		self
	}
}

extension SwitchFieldItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.content == rhs.content &&
		lhs.delegate === rhs.delegate &&
		lhs.fieldItem == rhs.fieldItem
	}
}

extension SwitchFieldItem: IItem {}

extension SwitchFieldItem: IFieldItemContainer {}
