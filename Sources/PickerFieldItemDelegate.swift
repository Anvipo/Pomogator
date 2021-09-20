//
//  PickerFieldItemDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

@MainActor
protocol PickerFieldItemDelegate: FieldItemDelegate {
	func pickerFieldItem<ID: IDType>(
		_ item: PickerFieldItem<ID>,
		shouldChangeValueToComponent component: PickerFieldItem<ID>.SelectedComponentInfo
	) -> Bool

	func pickerFieldItemDidChangeComponent<ID: IDType>(_ item: PickerFieldItem<ID>)
}

extension PickerFieldItemDelegate {
	func pickerFieldItem<ID: IDType>(
		_ item: PickerFieldItem<ID>,
		shouldChangeValueToComponent component: PickerFieldItem<ID>.SelectedComponentInfo
	) -> Bool { true }

	func pickerFieldItemDidChangeComponent<ID: IDType>(_ item: PickerFieldItem<ID>) {}
}
