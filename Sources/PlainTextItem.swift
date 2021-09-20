//
//  PlainTextItem.swift
//  Pomogator
//
//  Created by Anvipo on 27.09.2021.
//

import UIKit

// swiftlint:disable:next file_types_order
extension PlainTextItem {
	struct Content {
		let title: String
		var text: String
	}
}

@MainActor
struct PlainTextItem<ID: IDType>: ItemProtocol {
	var content: Content
	let id: ID
	var textColor: UIColor?
}

extension PlainTextItem: TableViewItemProtocol {
	func update(tableViewCell: UITableViewCell) {
		var contentConfiguration = UIListContentConfiguration.subtitleCell()
		contentConfiguration.text = content.text
		if let textColor {
			contentConfiguration.textProperties.color = textColor
		}
		contentConfiguration.secondaryText = content.title
		tableViewCell.contentConfiguration = contentConfiguration

		let backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
		tableViewCell.backgroundConfiguration = backgroundConfiguration
	}
}

extension PlainTextItem: ReusableTableViewItem {
	static var reuseID: String {
		"PlainTextItem"
	}
}
