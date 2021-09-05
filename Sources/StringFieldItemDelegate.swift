//
//  StringFieldItemDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

@MainActor
protocol StringFieldItemDelegate: FieldItemDelegate {
	func stringFieldItem<ID: IDType>(
		_ item: StringFieldItem<ID>,
		shouldChangeCharactersIn range: Range<String.Index>,
		replacementString: String
	) -> Bool

	func stringFieldItemFormattedString<ID: IDType>(_ item: StringFieldItem<ID>) -> String

	func stringFieldItemDidChangeString<ID: IDType>(_ item: StringFieldItem<ID>)
}

extension StringFieldItemDelegate {
	func stringFieldItem<ID: IDType>(
		_ item: StringFieldItem<ID>,
		shouldChangeCharactersIn range: Range<String.Index>,
		replacementString: String
	) -> Bool { true }

	func stringFieldItemFormattedString<ID: IDType>(_ item: StringFieldItem<ID>) -> String {
		item.content.text
	}

	func stringFieldItemDidChangeString<ID: IDType>(_ item: StringFieldItem<ID>) {}
}
