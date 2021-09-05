//
//  DateFieldItem.swift
//  Pomogator
//
//  Created by Anvipo on 11.09.2021.
//

import UIKit

@MainActor
struct DateFieldItem<ID: IDType> {
	let calendar: Calendar
	var content: Content
	let datePickerMode: UIDatePicker.Mode
	let datePickerStyle: UIDatePickerStyle
	let datePickerTintColor: UIColor
	weak var delegate: DateFieldItemDelegate?
	private(set) var fieldItem: FieldItem<ID>
	let getDateText: (Date) -> String
	let getDate: (String) -> Date?
	let shouldEraseSeconds: Bool
}

extension DateFieldItem: ItemProtocol {
	var id: ID {
		fieldItem.id
	}
}

extension DateFieldItem: ReusableTableViewItem {
	static var reuseID: String {
		"DateFieldItem"
	}
}

extension DateFieldItem: TableViewItemProtocol {
	func update(tableViewCell: UITableViewCell) {
		tableViewCell.contentConfiguration = self
	}
}

extension DateFieldItem: UIContentConfiguration {
	func makeContentView() -> UIView & UIContentView {
		DateFieldView(item: self)
	}

	func updated(for state: UIConfigurationState) -> Self {
		self
	}
}

extension DateFieldItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.calendar == rhs.calendar &&
		lhs.content == rhs.content &&
		lhs.datePickerMode == rhs.datePickerMode &&
		lhs.delegate === rhs.delegate &&
		lhs.fieldItem == rhs.fieldItem &&
		lhs.shouldEraseSeconds == rhs.shouldEraseSeconds
	}
}

extension DateFieldItem: FieldItemContainer {
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
