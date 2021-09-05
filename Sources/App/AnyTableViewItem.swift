//
//  AnyTableViewItem.swift
//  App
//
//  Created by Anvipo on 14.01.2023.
//

import UIKit

struct AnyTableViewItem<I: IDType> {
	let base: any IReusableTableViewItem

	init(_ base: any IReusableTableViewItem) {
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
		base.id as! ID
	}
}

extension AnyTableViewItem {
	var fieldItemContainer: (any IFieldItemContainer)? {
		base as? (any IFieldItemContainer)
	}
}

extension ITableViewItem where Self: IReuseIdentifiable {
	func eraseToAnyTableItem() -> AnyTableViewItem<ID> {
		AnyTableViewItem(self)
	}
}
