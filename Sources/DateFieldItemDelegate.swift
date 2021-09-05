//
//  DateFieldItemDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import Foundation

protocol DateFieldItemDelegate: FieldItemDelegate {
	func dateFieldItem<ID: Hashable>(
		_ item: DateFieldItem<ID>,
		shouldChangeTo newDate: Date
	) -> Bool

	func dateFieldItemDidChangeDate<ID: Hashable>(_ item: DateFieldItem<ID>)
}

extension DateFieldItemDelegate {
	func dateFieldItem<ID: Hashable>(
		_ item: DateFieldItem<ID>,
		shouldChangeTo newDate: Date
	) -> Bool { true }

	func dateFieldItemDidChangeDate<ID: Hashable>(_ item: DateFieldItem<ID>) {}
}
