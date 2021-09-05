//
//  StringFieldItem.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

@MainActor
struct StringFieldItem<ID: IDType> {
	var content: Content
	weak var delegate: StringFieldItemDelegate?
	private(set) var fieldItem: FieldItem<ID>
	let textKeyboardType: UIKeyboardType
}

extension StringFieldItem: IItem {
	var id: ID {
		fieldItem.id
	}
}

extension StringFieldItem: ReusableTableViewItem {
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

	func updated(for state: UIConfigurationState) -> Self {
		self
	}
}

extension StringFieldItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.content == rhs.content &&
		lhs.delegate === rhs.delegate &&
		lhs.fieldItem == rhs.fieldItem &&
		lhs.textKeyboardType == rhs.textKeyboardType
	}
}

extension StringFieldItem: FieldItemContainer {
	var toolbarItems: [UIBarButtonItem] {
		get { fieldItem.toolbarItems }
		set { fieldItem.toolbarItems = newValue }
	}

	var currentResponderProvider: CurrentResponderProvider {
		fieldItem.currentResponderProvider
	}

	var respondersNavigationFacade: RespondersNavigationFacade? {
		get { fieldItem.respondersNavigationFacade }
		set { fieldItem.respondersNavigationFacade = newValue }
	}
}
