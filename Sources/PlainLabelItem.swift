//
//  PlainLabelItem.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

@MainActor
struct PlainLabelItem<ID: IDType> {
	let accessoryInfo: TableViewCellAccessoryInfo?
	let backgroundColorHandler: ((UICellConfigurationState) -> UIColor)?
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

		tableViewCell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()

		tableViewCell.tintColor = tintColor
		accessoryInfo?.update(tableViewCell: tableViewCell)

		tableViewCell.configurationUpdateHandler = { cell, state in
			if let backgroundColorHandler {
				cell.backgroundConfiguration?.backgroundColor = backgroundColorHandler(state)
			}
		}
	}
}

extension PlainLabelItem: ReusableTableViewItem {
	static var reuseID: String {
		"PlainLabelItem"
	}
}
