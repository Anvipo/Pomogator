//
//  PlainLabelFooterItem.swift
//  App
//
//  Created by Anvipo on 01.12.2022.
//

import UIKit

struct PlainLabelFooterItem<ID: IDType> {
	let id: ID
	let style: PlainLabelFooterItemStyle
	let text: String
	let textProperties: UIListContentConfiguration.TextProperties
	let tintColorStyle: ColorStyle?
}

extension PlainLabelFooterItem: ITableViewHeaderFooterItem {
	func update(headerFooterView: UITableViewHeaderFooterView) {
		var contentConfiguration = Self.makeContentConfiguration(style: style)

		contentConfiguration.text = text
		contentConfiguration.textProperties = textProperties

		headerFooterView.contentConfiguration = contentConfiguration

		headerFooterView.backgroundConfiguration = Self.makeBackgroundConfiguration(style: style)

		headerFooterView.tintColor = tintColorStyle?.color
	}
}

extension PlainLabelFooterItem: IReuseIdentifiable {
	static var reuseID: String {
		"PlainLabelFooterItem"
	}
}

extension PlainLabelFooterItem: IReusableTableViewHeaderFooterItem {}

extension PlainLabelFooterItem {
	static func makeTextProperties(style: PlainLabelFooterItemStyle) -> UIListContentConfiguration.TextProperties {
		makeContentConfiguration(style: style).textProperties
	}
}

private extension PlainLabelFooterItem {
	static func makeContentConfiguration(style: PlainLabelFooterItemStyle) -> UIListContentConfiguration {
		switch style {
		case .plain: .footer()
		case .grouped: .footer()
		}
	}

	static func makeBackgroundConfiguration(style: PlainLabelFooterItemStyle) -> UIBackgroundConfiguration {
		switch style {
		case .plain: .listFooter()
		case .grouped: .listFooter()
		}
	}
}
