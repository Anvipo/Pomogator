//
//  IDateFieldItemDelegate.swift
//  App
//
//  Created by Anvipo on 12.09.2021.
//

import Foundation

protocol IDateFieldItemDelegate: ITextFieldItemDelegate {
	func dateFieldItem<ID: IDType>(
		_ item: DateFieldItem<ID>,
		shouldChangeTo newDate: Date
	) -> Bool

	func dateFieldItem<ID: IDType>(
		_ item: DateFieldItem<ID>,
		format date: Date
	) -> (text: String, accessibilityText: String)

	func dateFieldItemDidChangeValue<ID: IDType>(_ item: DateFieldItem<ID>)
}
