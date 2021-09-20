//
//  PickerFieldItem.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

import UIKit

@MainActor
struct PickerFieldItem<ID: IDType> {
	// swiftlint:disable:next implicitly_unwrapped_optional
	var container: PickerFieldItemContainer!
	weak var delegate: PickerFieldItemDelegate?
	private(set) var fieldItem: FieldItem<ID>
	var selectedComponent: SelectedComponentInfo
}

extension PickerFieldItem: IItem {
	var id: ID {
		fieldItem.id
	}
}

extension PickerFieldItem: UIContentConfiguration {
	func makeContentView() -> UIView & UIContentView {
		PickerFieldView(item: self)
	}

	func updated(for state: UIConfigurationState) -> Self {
		self
	}
}

extension PickerFieldItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.delegate === rhs.delegate &&
		lhs.fieldItem == rhs.fieldItem &&
		lhs.selectedComponent == rhs.selectedComponent
	}
}

extension PickerFieldItem: FieldItemContainer {
	var toolbarItems: [UIBarButtonItem] {
		get { fieldItem.toolbarItems }
		set { fieldItem.toolbarItems = newValue }
	}

	var currentResponderProvider: CurrentResponderProvider {
		fieldItem.currentResponderProvider
	}

	var respondersNavigationFacade: RespondersNavigationFacade? {
		get { fieldItem.respondersNavigationFacade }
		set { fieldItem.respondersNavigationFacade = newValue }
	}
}
