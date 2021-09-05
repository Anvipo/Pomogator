//
//  DateFieldItemDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import Foundation

@MainActor
protocol DateFieldItemDelegate: FieldItemDelegate {
	func dateFieldItem<ID: IDType>(
		_ item: DateFieldItem<ID>,
		shouldChangeTo newDate: Date
	) -> Bool

	func dateFieldItemDidChangeDate<ID: IDType>(_ item: DateFieldItem<ID>)
}

extension DateFieldItemDelegate {
	func dateFieldItem<ID: IDType>(
		_ item: DateFieldItem<ID>,
		shouldChangeTo newDate: Date
	) -> Bool { true }

	func dateFieldItemDidChangeDate<ID: IDType>(_ item: DateFieldItem<ID>) {}
}
