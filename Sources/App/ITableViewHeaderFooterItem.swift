//
//  ITableViewHeaderFooterItem.swift
//  App
//
//  Created by Anvipo on 27.08.2022.
//

import UIKit

protocol ITableViewHeaderFooterItem: IItem {
	func update(headerFooterView: UITableViewHeaderFooterView)
}

extension UITableView {
	func dequeueAndConfigureHeaderFooterView<T: IReusableTableViewHeaderFooterItem>(item: T) -> UITableViewHeaderFooterView? {
		let itemType = type(of: item)

		register(itemType: itemType)

		guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: itemType.reuseID) else {
			assertionFailure("?")
			return nil
		}

		item.update(headerFooterView: headerFooterView)

		return headerFooterView
	}
}

private extension UITableView {
	func register<T: IReusableTableViewHeaderFooterItem>(itemType: T.Type) {
		register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: itemType.reuseID)
	}
}
