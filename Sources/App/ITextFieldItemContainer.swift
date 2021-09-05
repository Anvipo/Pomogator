//
//  ITextFieldItemContainer.swift
//  App
//
//  Created by Anvipo on 12.03.2023.
//

import UIKit

protocol ITextFieldItemContainer: IFieldItemContainer {
	var textFieldItem: TextFieldItem<ID> { get set }
	var toolbarItems: [UIBarButtonItem] { get set }
	var toolbarNavigationItemsManager: TextFieldItemToolbarNavigationItemsManager { get }
}

extension ITextFieldItemContainer {
	var fieldItem: FieldItem<ID> {
		textFieldItem.fieldItem
	}

	var toolbarItems: [UIBarButtonItem] {
		get { textFieldItem.toolbarItems }
		set { textFieldItem.toolbarItems = newValue }
	}

	var toolbarNavigationItemsManager: TextFieldItemToolbarNavigationItemsManager {
		textFieldItem.toolbarNavigationItemsManager
	}
}
