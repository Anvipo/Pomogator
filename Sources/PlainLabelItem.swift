//
//  PlainLabelItem.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

struct PlainLabelItem<ID: Hashable>: ItemProtocol {
	let accessoryInfo: TableViewCellAccessoryInfo?
	let backgroundColor: UIColor?
	let id: ID
	let text: String
	let textAlignment: UIListContentConfiguration.TextProperties.TextAlignment
	let textColor: UIColor
	let textFont: UIFont
	let tintColor: UIColor?
}

extension PlainLabelItem: TableViewItemProtocol {
	func update(tableViewCell: UITableViewCell) {
		var contentConfiguration = UIListContentConfiguration.cell()
		contentConfiguration.text = text
		contentConfiguration.textProperties.alignment = textAlignment
		contentConfiguration.textProperties.font = textFont
		contentConfiguration.textProperties.color = textColor
		tableViewCell.contentConfiguration = contentConfiguration

		var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
		if let backgroundColor {
			backgroundConfiguration.backgroundColor = backgroundColor
		}
		tableViewCell.backgroundConfiguration = backgroundConfiguration

		tableViewCell.tintColor = tintColor
		accessoryInfo?.update(tableViewCell: tableViewCell)
	}
}
