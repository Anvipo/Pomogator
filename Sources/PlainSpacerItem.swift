//
//  PlainSpacerItem.swift
//  Pomogator
//
//  Created by Anvipo on 12.12.2022.
//

import UIKit

@MainActor
struct PlainSpacerItem<ID: IDType>: ItemProtocol {
	let backgroundConfiguration: UIBackgroundConfiguration?
	let id: ID
	let type: SpacerType
}

extension PlainSpacerItem: UIContentConfiguration {
	func makeContentView() -> UIView & UIContentView {
		PlainSpacerView(item: self)
	}

	func updated(for state: UIConfigurationState) -> Self {
		self
	}
}

extension PlainSpacerItem: TableViewItemProtocol {
	func update(tableViewCell: UITableViewCell) {
		tableViewCell.backgroundConfiguration = backgroundConfiguration
		tableViewCell.contentConfiguration = self
	}
}

extension PlainSpacerItem: ReusableTableViewItem {
	static var reuseID: String {
		"PlainSpacerItem"
	}
}

extension PlainSpacerItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.id == rhs.id &&
		lhs.type == rhs.type
	}
}
