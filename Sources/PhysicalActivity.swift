//
//  PhysicalActivity.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

import Foundation

typealias PhysicalActivityPickerFieldItem<ID: IDType> = ValuePickerFieldItem<PhysicalActivity, ID>

enum PhysicalActivity: Int {
	case minimal
	case low
	case medium
	case high
	case extreme
}

extension PhysicalActivity: PickerFieldItemPresentable {
	var string: String {
		switch self {
		case .minimal:
			return String(localized: "Minimal")

		case .low:
			return String(localized: "Low")

		case .medium:
			return String(localized: "Medium")

		case .high:
			return String(localized: "High")

		case .extreme:
			return String(localized: "Extreme")
		}
	}
}

extension PhysicalActivity {
	var value: Decimal {
		switch self {
		case .minimal:
			return "1.2".decimalFromEN

		case .low:
			return "1.375".decimalFromEN

		case .medium:
			return "1.55".decimalFromEN

		case .high:
			return "1.7".decimalFromEN

		case .extreme:
			return "1.9".decimalFromEN
		}
	}
}

extension PhysicalActivity: CaseIterable {}
