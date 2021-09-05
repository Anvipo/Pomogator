//
//  UITraitCollection+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 19.09.2024.
//

import UIKit

extension UITraitCollection {
	func hasDifferentPreferredContentSizeCategory(comparedTo otherTraitCollection: UITraitCollection) -> Bool {
		self.preferredContentSizeCategory != otherTraitCollection.preferredContentSizeCategory
	}
}
