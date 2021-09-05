//
//  UIDatePicker.Mode.swift
//  Pomogator
//
//  Created by Anvipo on 28.08.2022.
//

import UIKit

extension UIDatePicker.Mode: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.rawValue == rhs.rawValue
	}
}
