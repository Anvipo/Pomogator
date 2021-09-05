//
//  PlainLabelHeaderItem.swift
//  App
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

struct PlainLabelHeaderItem<ID: IDType> {
	let content: Content
	let id: ID
	let style: PlainLabelHeaderItemStyle
	let tintColorStyle: ColorStyle?
}

extension PlainLabelHeaderItem: ITableViewHeaderFooterItem {
	func update(headerFooterView: UITableViewHeaderFooterView) {
		var contentConfiguration = Self.makeContentConfiguration(style: style)

		contentConfiguration.text = content.text

		headerFooterView.contentConfiguration = contentConfiguration

		headerFooterView.backgroundConfiguration = Self.makeBackgroundConfiguration(style: style)

		headerFooterView.tintColor = tintColorStyle?.color

		headerFooterView.accessibilityLabel = content.accessibilityLabel
	}
}

extension PlainLabelHeaderItem: IReuseIdentifiable {
	static var reuseID: String {
		"PlainLabelHeaderItem"
	}
}

extension PlainLabelHeaderItem: IReusableTableViewHeaderFooterItem {}

private extension PlainLabelHeaderItem {
	static func makeContentConfiguration(style: PlainLabelHeaderItemStyle) -> UIListContentConfiguration {
		switch style {
		case .plain: .header()
		case .grouped: .header()
		case .sidebar: .header()
		case .prominentInsetGrouped: .prominentInsetGroupedHeader()
		case .extraProminentInsetGrouped: .extraProminentInsetGroupedHeader()
		}
	}

	static func makeBackgroundConfiguration(style: PlainLabelHeaderItemStyle) -> UIBackgroundConfiguration {
		switch style {
		case .plain: .listHeader()
		case .grouped, .prominentInsetGrouped, .extraProminentInsetGrouped: .listHeader()
		case .sidebar: .listHeader()
		}
	}
}
