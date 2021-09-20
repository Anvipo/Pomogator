//
//  PickerFieldView.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

import UIKit

final class PickerFieldView<ID: IDType>: FieldView<ID>, UIPickerViewDelegate, UIPickerViewDataSource {
	private let pickerView: UIPickerView
	private var lastChosenComponent: PickerFieldItem<ID>.SelectedComponentInfo?
	// swiftlint:disable:next implicitly_unwrapped_optional
	private var item: PickerFieldItem<ID>!

	init(item: PickerFieldItem<ID>) {
		pickerView = UIPickerView()

		super.init(frame: .zero)

		setupUI()
		configure(with: item)
	}

	override func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		false
	}

	// MARK: - UIPickerViewDataSource

	func numberOfComponents(
		in pickerView: UIPickerView
	) -> Int {
		item.container.numberOfComponents
	}

	func pickerView(
		_ pickerView: UIPickerView,
		numberOfRowsInComponent component: Int
	) -> Int {
		item.container.numberOfRows(in: component)
	}

	// MARK: - UIPickerViewDelegate

	func pickerView(
		_ pickerView: UIPickerView,
		titleForRow row: Int,
		forComponent component: Int
	) -> String? {
		let component = PickerFieldItem<ID>.SelectedComponentInfo(
			componentIndex: component,
			componentRowIndex: row
		)

		return item.container.text(for: component)
	}

	func pickerView(
		_ pickerView: UIPickerView,
		didSelectRow row: Int,
		inComponent component: Int
	) {
		let newComponent = PickerFieldItem<ID>.SelectedComponentInfo(
			componentIndex: component,
			componentRowIndex: row
		)

		let shouldChange = item.delegate?.pickerFieldItem(
			item,
			shouldChangeValueToComponent: newComponent
		) ?? true

		if shouldChange {
			lastChosenComponent = newComponent
			item.selectedComponent = newComponent

			set(text: item.container.text(for: newComponent))

			item.delegate?.pickerFieldItemDidChangeComponent(item)
		} else if let lastChosenComponent {
			pickerView.selectRow(
				lastChosenComponent.componentRowIndex,
				inComponent: lastChosenComponent.componentIndex,
				animated: isAddedToWindow
			)
		} else {
			assertionFailure("?")
		}
	}
}

extension PickerFieldView: UIContentView {
	var configuration: UIContentConfiguration {
		get {
			item
		}
		set {
			let pickerFieldItem: PickerFieldItem<ID>
			if let physicalActivityPickerFieldItem = newValue as? PhysicalActivityPickerFieldItem<ID> {
				pickerFieldItem = physicalActivityPickerFieldItem.pickerFieldItem
			} else if let personSexPickerFieldItem = newValue as? PersonSexPickerFieldItem<ID> {
				pickerFieldItem = personSexPickerFieldItem.pickerFieldItem
			} else if let newPickerFieldItem = newValue as? PickerFieldItem<ID> {
				pickerFieldItem = newPickerFieldItem
			} else {
				assertionFailure("Неподдерживаемая конфигурация:\n\(newValue)")
				return
			}

			configure(with: pickerFieldItem)
		}
	}

	func supports(_ configuration: UIContentConfiguration) -> Bool {
		if configuration is PhysicalActivityPickerFieldItem<ID> {
			return true
		} else if configuration is PersonSexPickerFieldItem<ID> {
			return true
		} else if configuration is PickerFieldItem<ID> {
			return true
		} else {
			return false
		}
	}
}

private extension PickerFieldView {
	func setupUI() {
		pickerView.delegate = self
		pickerView.dataSource = self
		set(inputView: pickerView)
	}

	func configure(with item: PickerFieldItem<ID>) {
		guard self.item != item else {
			return
		}

		self.item = item

		baseConfigure(with: item.fieldItem)

		pickerView.tintColor = item.fieldItem.tintColor
		lastChosenComponent = item.selectedComponent

		// попытка пофиксить UITableViewAlertForLayoutOutsideViewHierarchy
		if pickerView.isAddedToWindow {
			pickerView.selectRow(
				item.selectedComponent.componentRowIndex,
				inComponent: item.selectedComponent.componentIndex,
				animated: true
			)
		} else {
			UIView.performWithoutAnimation {
				pickerView.selectRow(
					item.selectedComponent.componentRowIndex,
					inComponent: item.selectedComponent.componentIndex,
					animated: false
				)
			}
		}

		set(icon: item.container.icon)
		set(title: item.container.title)
		set(text: item.container.text(for: item.selectedComponent))
	}
}
