//
//  PlainButtonItem.swift
//  Pomogator
//
//  Created by Anvipo on 22.09.2021.
//

import UIKit

@MainActor
struct PlainButtonItem<ID: IDType>: IItem {
	let accessoryButtonFullConfiguration: Button.FullConfiguration?
	let backgroundConfiguration: UIBackgroundConfiguration?
	let buttonFullConfiguration: Button.FullConfiguration
	let id: ID
}

extension PlainButtonItem: UIContentConfiguration {
	func makeContentView() -> UIView & UIContentView {
		PlainButtonView(item: self)
	}

	func updated(for state: UIConfigurationState) -> Self {
		self
	}
}

extension PlainButtonItem: ITableViewItem {
	func update(tableViewCell: UITableViewCell) {
		tableViewCell.backgroundConfiguration = backgroundConfiguration
		tableViewCell.contentConfiguration = self
	}
}

extension PlainButtonItem: ReusableTableViewItem {
	static var reuseID: String {
		"PlainButtonItem"
	}
}

extension PlainButtonItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.accessoryButtonFullConfiguration == rhs.accessoryButtonFullConfiguration &&
		lhs.backgroundConfiguration == rhs.backgroundConfiguration &&
		lhs.buttonFullConfiguration == rhs.buttonFullConfiguration &&
		lhs.id == rhs.id
	}
}
