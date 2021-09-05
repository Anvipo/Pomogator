//
//  ITableViewItem.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2022.
//

import UIKit

@MainActor
protocol ITableViewItem: IItem {
	func update(tableViewCell: UITableViewCell)
}

extension UITableView {
	func dequeueAndConfigureCell<T: ReusableTableViewItem>(
		indexPath: IndexPath,
		item: T
	) -> UITableViewCell {
		let itemType = type(of: item)

		register(itemType: itemType)

		let cell = dequeueReusableCell(withIdentifier: itemType.reuseID, for: indexPath)

		item.update(tableViewCell: cell)

		return cell
	}
}

private extension UITableView {
	func register<T: ReusableTableViewItem>(itemType: T.Type) {
		register(UITableViewCell.self, forCellReuseIdentifier: itemType.reuseID)
	}
}
