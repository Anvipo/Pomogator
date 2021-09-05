//
//  TableViewHeaderFooterItemProtocol.swift
//  Pomogator
//
//  Created by Anvipo on 27.08.2022.
//

import UIKit

protocol TableViewHeaderFooterItemProtocol {
	func update(headerFooterView: UITableViewHeaderFooterView)
}

extension UITableView {
	func dequeueAndConfigureHeaderFooterView(
		reuseID: String,
		item: TableViewHeaderFooterItemProtocol
	) -> UITableViewHeaderFooterView? {
		guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: reuseID) else {
			return nil
		}

		item.update(headerFooterView: headerFooterView)

		return headerFooterView
	}
}
