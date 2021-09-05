//
//  FieldItem.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

import UIKit

@MainActor
struct FieldItem<ID: IDType>: IItem {
	let backgroundColor: UIColor
	let contentInsets: NSDirectionalEdgeInsets
	let currentResponderProvider: CurrentResponderProvider
	weak var delegate: FieldItemDelegate?
	let iconTintColor: UIColor?
	let id: ID
	var respondersNavigationFacade: RespondersNavigationFacade?
	let textColor: UIColor
	let textFieldBorderStyle: UITextField.BorderStyle
	let textFieldTintColor: UIColor
	let textFont: UIFont
	let tintColor: UIColor
	let titleColor: UIColor
	let titleFont: UIFont
	let titleNumberOfLines: Int
	let titleTintColor: UIColor
	var toolbarItems: [UIBarButtonItem]
	let toolbarTintColor: UIColor
}

extension FieldItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.backgroundColor == rhs.backgroundColor &&
		lhs.contentInsets == rhs.contentInsets &&
		lhs.currentResponderProvider === rhs.currentResponderProvider &&
		lhs.delegate === rhs.delegate &&
		lhs.iconTintColor == rhs.iconTintColor &&
		lhs.id == rhs.id &&
		lhs.respondersNavigationFacade == rhs.respondersNavigationFacade &&
		lhs.textColor == rhs.textColor &&
		lhs.textFieldBorderStyle == rhs.textFieldBorderStyle &&
		lhs.textFieldTintColor == rhs.textFieldTintColor &&
		lhs.textFont == rhs.textFont &&
		lhs.tintColor == rhs.tintColor &&
		lhs.titleColor == rhs.titleColor &&
		lhs.titleFont == rhs.titleFont &&
		lhs.titleNumberOfLines == rhs.titleNumberOfLines &&
		lhs.titleTintColor == rhs.titleTintColor &&
		lhs.toolbarItems == rhs.toolbarItems &&
		lhs.toolbarTintColor == rhs.toolbarTintColor
	}
}
