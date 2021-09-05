//
//  ITextFieldItemDelegate.swift
//  App
//
//  Created by Anvipo on 12.03.2023.
//

protocol ITextFieldItemDelegate: IFieldItemDelegate {
	func textFieldItemDidBeginEditing<ID: IDType>(_ item: TextFieldItem<ID>)

	func textFieldItemDidEndEditing<ID: IDType>(_ item: TextFieldItem<ID>)
}
