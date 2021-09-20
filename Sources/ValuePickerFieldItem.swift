//
//  ValuePickerFieldItem.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

import UIKit

@MainActor
struct ValuePickerFieldItem<V: PickerFieldItemPresentable, ID: IDType> {
	let content: PickerFieldItem<ID>.Content<V>
	var pickerFieldItem: PickerFieldItem<ID>

	init(
		content: PickerFieldItem<ID>.Content<V>,
		pickerFieldItem: PickerFieldItem<ID>
	) {
		self.content = content
		self.pickerFieldItem = pickerFieldItem

		var copyPickerFieldItem = self.pickerFieldItem
		copyPickerFieldItem.container = self
		self.pickerFieldItem = copyPickerFieldItem
	}
}

extension ValuePickerFieldItem: ItemProtocol {
	var id: ID {
		pickerFieldItem.id
	}
}

extension ValuePickerFieldItem: ReusableTableViewItem {
	static var reuseID: String {
		"ValuePickerFieldItem"
	}
}

extension ValuePickerFieldItem: TableViewItemProtocol {
	func update(tableViewCell: UITableViewCell) {
		tableViewCell.contentConfiguration = self
	}
}

extension ValuePickerFieldItem: UIContentConfiguration {
	func makeContentView() -> UIView & UIContentView {
		PickerFieldView(item: pickerFieldItem)
	}

	func updated(for state: UIConfigurationState) -> Self {
		self
	}
}

extension ValuePickerFieldItem: PickerFieldItemContainer {
	var icon: UIImage {
		content.icon
	}

	var title: String {
		content.title
	}

	var numberOfComponents: Int {
		content.data.count
	}

	func numberOfRows(in component: Int) -> Int {
		content.data[component].count
	}

	func text<ID: IDType>(for selectedComponent: PickerFieldItem<ID>.SelectedComponentInfo) -> String {
		content.data[selectedComponent.componentIndex][selectedComponent.componentRowIndex].string
	}
}

extension ValuePickerFieldItem: FieldItemContainer {
	var toolbarItems: [UIBarButtonItem] {
		get { pickerFieldItem.toolbarItems }
		set { pickerFieldItem.toolbarItems = newValue }
	}

	var currentResponderProvider: CurrentResponderProvider {
		pickerFieldItem.currentResponderProvider
	}

	var respondersNavigationFacade: RespondersNavigationFacade? {
		get { pickerFieldItem.respondersNavigationFacade }
		set { pickerFieldItem.respondersNavigationFacade = newValue }
	}
}
