//
//  IStringFieldItemDelegate.swift
//  App
//
//  Created by Anvipo on 12.09.2021.
//

protocol IStringFieldItemDelegate: ITextFieldItemDelegate {
	func stringFieldItem<ID: IDType>(
		_ item: StringFieldItem<ID>,
		shouldChangeCharactersIn range: Range<String.Index>,
		replacementString: String
	) -> Bool

	func stringFieldItemFormattedString<ID: IDType>(_ item: StringFieldItem<ID>) -> String

	func stringFieldItemDidChangeValue<ID: IDType>(_ item: StringFieldItem<ID>)
}
