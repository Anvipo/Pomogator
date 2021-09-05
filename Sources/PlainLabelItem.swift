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
	let textProperties: UIListContentConfiguration.TextProperties

	let tintColor: UIColor?
}

extension PlainLabelItem: ITableViewItem {
	func update(tableViewCell: UITableViewCell) {
		var contentConfiguration = Self.makeContentConfiguration()

		contentConfiguration.text = text
		contentConfiguration.textProperties = textProperties

		tableViewCell.contentConfiguration = contentConfiguration
		tableViewCell.configurationUpdateHandler = { cell, state in
			if let backgroundColorHandler {
				cell.backgroundConfiguration?.backgroundColor = backgroundColorHandler(state)
			}
		}

		tableViewCell.backgroundConfiguration = Self.makeBackgroundConfiguration()

		tableViewCell.tintColor = tintColor

		accessoryInfo?.update(tableViewCell: tableViewCell)
	}
}

extension PlainLabelItem: ReusableTableViewItem {
	static var reuseID: String {
		"PlainLabelItem"
	}
}

extension PlainLabelItem {
	static func makeTextProperties() -> UIListContentConfiguration.TextProperties {
		makeContentConfiguration().textProperties
	}
}

private extension PlainLabelItem {
	static func makeContentConfiguration() -> UIListContentConfiguration {
		.cell()
	}

	static func makeBackgroundConfiguration() -> UIBackgroundConfiguration {
		.listGroupedCell()
	}
}
