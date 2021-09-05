//
//  FieldItem.swift
//  App
//
//  Created by Anvipo on 26.09.2021.
//

import UIKit

struct FieldItem<ID: IDType>: IItem {
	let accessibilityInfoProvider: FieldItemAccessibilityInfoProvider
	let accessoryButtonFullConfiguration: Button.FullConfiguration?
	let backgroundColorStyle: ColorStyle
	let contentInsets: NSDirectionalEdgeInsets
	weak var delegate: IFieldItemDelegate?
	let iconAdjustsImageSizeForAccessibilityContentSizeCategory: Bool
	let iconTintColorStyle: ColorStyle?
	let id: ID
	let respondersFacade: FieldItemRespondersFacade
	let tintColorStyle: ColorStyle
	let titleAdjustsFontForContentSizeCategory: Bool
	let titleColorStyle: ColorStyle
	let titleFontStyle: FontStyle
	let titleNumberOfLines: Int
	let titleTintColorStyle: ColorStyle
}

extension FieldItem: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.accessibilityInfoProvider === rhs.accessibilityInfoProvider &&
		lhs.accessoryButtonFullConfiguration == rhs.accessoryButtonFullConfiguration &&
		lhs.backgroundColorStyle == rhs.backgroundColorStyle &&
		lhs.contentInsets == rhs.contentInsets &&
		lhs.delegate === rhs.delegate &&
		lhs.iconAdjustsImageSizeForAccessibilityContentSizeCategory == rhs.iconAdjustsImageSizeForAccessibilityContentSizeCategory &&
		lhs.iconTintColorStyle == rhs.iconTintColorStyle &&
		lhs.id == rhs.id &&
		lhs.respondersFacade === rhs.respondersFacade &&
		lhs.tintColorStyle == rhs.tintColorStyle &&
		lhs.titleAdjustsFontForContentSizeCategory == rhs.titleAdjustsFontForContentSizeCategory &&
		lhs.titleColorStyle == rhs.titleColorStyle &&
		lhs.titleFontStyle == rhs.titleFontStyle &&
		lhs.titleNumberOfLines == rhs.titleNumberOfLines &&
		lhs.titleTintColorStyle == rhs.titleTintColorStyle
	}
}
