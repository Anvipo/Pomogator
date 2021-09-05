//
//  PlainLabelItem.swift
//  App
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

struct PlainLabelItem<ID: IDType> {
	let accessoryInfo: TableViewCellAccessoryInfo?

	let accessibilityTraits: UIAccessibilityTraits

	var backgroundColorHandler: ((UICellConfigurationState) -> UIColor)?

	let content: Content

	var id: ID

	let pointerInteractionDelegate: UIPointerInteractionDelegate?

	let style: PlainLabelItemStyle

	var textProperties: UIListContentConfiguration.TextProperties

	let tintColorStyle: ColorStyle?
}

extension PlainLabelItem: ITableViewItem {
	func update(tableViewCell: UITableViewCell) {
		var contentConfiguration = Self.makeContentConfiguration()

		contentConfiguration.text = content.text
		contentConfiguration.textProperties = textProperties

		tableViewCell.contentConfiguration = contentConfiguration
		tableViewCell.configurationUpdateHandler = { cell, state in
			if let backgroundColorHandler {
				cell.backgroundConfiguration?.backgroundColor = backgroundColorHandler(state)
			}
		}

		tableViewCell.backgroundConfiguration = Self.makeBackgroundConfiguration(style: style)

		tableViewCell.updateAccessory(with: accessoryInfo)

		tableViewCell.tintColor = tintColorStyle?.color

		if let pointerInteractionDelegate {
			tableViewCell.addPointerInteraction(delegate: pointerInteractionDelegate)
		}

		tableViewCell.accessibilityTraits = accessibilityTraits
		tableViewCell.accessibilityLabel = content.customAccessibilityLabel
		tableViewCell.accessibilityValue = content.customAccessibilityValue
	}
}

extension PlainLabelItem: IReuseIdentifiable {
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

	static func makeBackgroundConfiguration(style: PlainLabelItemStyle) -> UIBackgroundConfiguration {
		switch style {
		case .plain: .listCell()
		case .grouped: .listCell()
		case .sidebar: .listCell()
		case .accompaniedSidebar: .listAccompaniedSidebarCell()
		}
	}
}
