//
//  PlainLabelFooterItem.swift
//  Pomogator
//
//  Created by Anvipo on 01.12.2022.
//

import UIKit

@MainActor
struct PlainLabelFooterItem<ID: IDType> {
	let id: ID
	let text: String
	var textColor: UIColor?
}

extension PlainLabelFooterItem: ITableViewHeaderFooterItem {
	func update(headerFooterView: UITableViewHeaderFooterView) {
		var contentConfiguration = UIListContentConfiguration.groupedFooter()
		contentConfiguration.text = text
		if let textColor {
			contentConfiguration.textProperties.color = textColor
		}
		headerFooterView.contentConfiguration = contentConfiguration

		let backgroundConfiguration = UIBackgroundConfiguration.listGroupedHeaderFooter()
		headerFooterView.backgroundConfiguration = backgroundConfiguration
	}
}

extension PlainLabelFooterItem: ReusableTableViewHeaderFooterItem {
	static var reuseID: String {
		"PlainLabelFooterItem"
	}
}
