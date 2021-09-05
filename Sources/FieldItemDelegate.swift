//
//  FieldItemDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

@MainActor
protocol FieldItemDelegate: AnyObject {
	func fieldItemDidBeginEditing<ID: IDType>(_ item: FieldItem<ID>)

	func fieldItemDidEndEditing<ID: IDType>(_ item: FieldItem<ID>)
}

extension FieldItemDelegate {
	func fieldItemDidBeginEditing<ID: IDType>(_ item: FieldItem<ID>) {}

	func fieldItemDidEndEditing<ID: IDType>(_ item: FieldItem<ID>) {}
}
