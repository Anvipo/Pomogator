//
//  PersonSex.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

import Foundation

typealias PersonSexPickerFieldItem<ID: IDType> = ValuePickerFieldItem<PersonSex, ID>

enum PersonSex {
	case male
	case female
}

extension PersonSex: PickerFieldItemPresentable {
	var string: String {
		switch self {
		case .male:
			return String(localized: "Male")

		case .female:
			return String(localized: "Female")
		}
	}
}

extension PersonSex {
	var kilocaloriesMinimum: Decimal {
		switch self {
		case .male:
			return "1400".decimalFromEN

		case .female:
			return "1200".decimalFromEN
		}
	}
}

extension PersonSex: CaseIterable {}
