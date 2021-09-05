//
//  ITableViewItem.swift
//  App
//
//  Created by Anvipo on 05.09.2022.
//

import UIKit

protocol ITableViewItem: IItem {
	func update(tableViewCell: UITableViewCell)
}

extension UITableView {
	func dequeueAndConfigureCell<T: IReusableTableViewItem>(
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
	func register<T: IReusableTableViewItem>(itemType: T.Type) {
		register(UITableViewCell.self, forCellReuseIdentifier: itemType.reuseID)
	}
}
