//
//  TableViewItemProtocol.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2022.
//

import UIKit

protocol TableViewItemProtocol: ItemProtocol {
	func update(tableViewCell: UITableViewCell)
}

extension UITableView {
	func dequeueAndConfigureCell(reuseID: String, indexPath: IndexPath, item: any TableViewItemProtocol) -> UITableViewCell {
		let cell = dequeueReusableCell(withIdentifier: reuseID, for: indexPath)

		item.update(tableViewCell: cell)

		return cell
	}
}
