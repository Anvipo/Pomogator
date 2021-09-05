//
//  AnyTableViewItem.swift
//  Pomogator
//
//  Created by Anvipo on 14.01.2023.
//

import UIKit

@MainActor
struct AnyTableViewItem<I: IDType> {
	let base: any ReusableTableViewItem

	init(_ base: any ReusableTableViewItem) {
		self.base = base
	}
}

extension AnyTableViewItem: ITableViewItem {
	func update(tableViewCell: UITableViewCell) {
		base.update(tableViewCell: tableViewCell)
	}
}

extension AnyTableViewItem: IItem {
	typealias ID = I

	var id: ID {
		// swiftlint:disable:next force_cast
		base.id as! ID
	}
}

@MainActor
extension Array where Element: ReusableTableViewItem {
	func eraseToAnyTableItems() -> [AnyTableViewItem<Element.ID>] {
		map { $0.eraseToAnyTableItem() }
	}
}

extension ReusableTableViewItem {
	func eraseToAnyTableItem() -> AnyTableViewItem<ID> {
		AnyTableViewItem(self)
	}
}
