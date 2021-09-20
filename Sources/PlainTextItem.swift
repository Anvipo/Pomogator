//
//  PlainTextItem.swift
//  Pomogator
//
//  Created by Anvipo on 27.09.2021.
//

import UIKit

@MainActor
struct PlainTextItem<ID: IDType>: IItem {
	let accessoryInfo: TableViewCellAccessoryInfo?
	let backgroundColorHandler: ((UICellConfigurationState) -> UIColor)?
	let id: ID

	let text: String
	let textProperties: UIListContentConfiguration.TextProperties

	let secondaryText: String
	let secondaryTextProperties: UIListContentConfiguration.TextProperties

	let tintColor: UIColor?
}

extension PlainTextItem: ITableViewItem {
	func update(tableViewCell: UITableViewCell) {
		var contentConfiguration = Self.makeContentConfiguration()

		contentConfiguration.text = text
		contentConfiguration.textProperties = textProperties

		contentConfiguration.secondaryText = secondaryText
		contentConfiguration.secondaryTextProperties = secondaryTextProperties

		tableViewCell.contentConfiguration = contentConfiguration
		tableViewCell.configurationUpdateHandler = { cell, state in
			if let backgroundColorHandler {
				cell.backgroundConfiguration?.backgroundColor = backgroundColorHandler(state)
			}
		}

		tableViewCell.tintColor = tintColor

		tableViewCell.backgroundConfiguration = Self.makeBackgroundConfiguration()

		accessoryInfo?.update(tableViewCell: tableViewCell)
	}
}

extension PlainTextItem: ReusableTableViewItem {
	static var reuseID: String {
		"PlainTextItem"
	}
}

extension PlainTextItem {
	static func makeTextProperties() -> UIListContentConfiguration.TextProperties {
		makeContentConfiguration().textProperties
	}

	static func makeSecondaryTextProperties() -> UIListContentConfiguration.TextProperties {
		makeContentConfiguration().secondaryTextProperties
	}
}

private extension PlainTextItem {
	static func makeContentConfiguration() -> UIListContentConfiguration {
		.subtitleCell()
	}

	static func makeBackgroundConfiguration() -> UIBackgroundConfiguration {
		.listGroupedCell()
	}
}
