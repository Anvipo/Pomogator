//
//  PlainLabelHeaderItem.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

struct PlainLabelHeaderItem {
	var text: String
}

extension PlainLabelHeaderItem: TableViewHeaderFooterItemProtocol {
	func update(headerFooterView: UITableViewHeaderFooterView) {
		var contentConfiguration = UIListContentConfiguration.extraProminentInsetGroupedHeader()
		contentConfiguration.text = text
		headerFooterView.contentConfiguration = contentConfiguration

		let backgroundConfiguration = UIBackgroundConfiguration.listGroupedHeaderFooter()
		headerFooterView.backgroundConfiguration = backgroundConfiguration
	}
}
