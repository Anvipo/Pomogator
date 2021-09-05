//
//  AnyTableItem.swift
//  Pomogator
//
//  Created by Anvipo on 14.01.2023.
//

import UIKit

struct AnyTableItem<I: Hashable> {
	private let base: any TableViewItemProtocol

	init(_ base: any TableViewItemProtocol) {
		self.base = base
	}
}

extension AnyTableItem: TableViewItemProtocol {
	typealias ID = I

	var id: ID {
		// swiftlint:disable:next force_cast
		base.id as! ID
	}

	func update(tableViewCell: UITableViewCell) {
		base.update(tableViewCell: tableViewCell)
	}
}

extension Array where Element: TableViewItemProtocol {
	func eraseToAnyTableItems() -> [AnyTableItem<Element.ID>] {
		map { $0.eraseToAnyTableItem() }
	}
}

extension TableViewItemProtocol {
	func eraseToAnyTableItem() -> AnyTableItem<ID> {
		AnyTableItem(self)
	}
}
