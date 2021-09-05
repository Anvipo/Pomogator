//
//  FieldItemDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

protocol FieldItemDelegate: AnyObject {
	func fieldItemDidBeginEditing<ID: Hashable>(_ item: FieldItem<ID>)

	func fieldItemDidEndEditing<ID: Hashable>(_ item: FieldItem<ID>)
}

extension FieldItemDelegate {
	func fieldItemDidBeginEditing<ID: Hashable>(_ item: FieldItem<ID>) {}

	func fieldItemDidEndEditing<ID: Hashable>(_ item: FieldItem<ID>) {}
}
