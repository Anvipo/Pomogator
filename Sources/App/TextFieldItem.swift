//
//  TextFieldItem.swift
//  App
//
//  Created by Anvipo on 12.03.2023.
//

import UIKit

struct TextFieldItem<ID: IDType> {
	weak var delegate: ITextFieldItemDelegate?
	private(set) var fieldItem: FieldItem<ID>
	let placeholder: String
	let textAdjustsFontForContentSizeCategory: Bool
	let textAdjustsFontSizeToFitWidth: Bool
	let textColorStyle: ColorStyle
	let textFieldBorderStyle: UITextField.BorderStyle
	let textFieldInputTraits: TextInputTraits
	let textFieldTintColorStyle: ColorStyle
	let textFontStyle: FontStyle
	var toolbarItems: [UIBarButtonItem]
	let toolbarNavigationItemsManager: TextFieldItemToolbarNavigationItemsManager
	let toolbarTintColorStyle: ColorStyle
}

extension TextFieldItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.delegate === rhs.delegate &&
		lhs.fieldItem == rhs.fieldItem &&
		lhs.textAdjustsFontForContentSizeCategory == rhs.textAdjustsFontForContentSizeCategory &&
		lhs.textAdjustsFontSizeToFitWidth == rhs.textAdjustsFontSizeToFitWidth &&
		lhs.textColorStyle == rhs.textColorStyle &&
		lhs.textFieldBorderStyle == rhs.textFieldBorderStyle &&
		lhs.textFieldInputTraits == rhs.textFieldInputTraits &&
		lhs.textFieldTintColorStyle == rhs.textFieldTintColorStyle &&
		lhs.textFontStyle == rhs.textFontStyle &&
		lhs.toolbarItems == rhs.toolbarItems &&
		lhs.toolbarNavigationItemsManager === rhs.toolbarNavigationItemsManager &&
		lhs.toolbarTintColorStyle == rhs.toolbarTintColorStyle
	}
}

extension TextFieldItem: IItem {}

extension TextFieldItem: IFieldItemContainer {}
