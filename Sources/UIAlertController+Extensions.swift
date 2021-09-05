//
//  UIAlertController+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import UIKit

extension UIAlertController {
	static func alert(
		title: String?,
		message: String?,
		actions: [UIAlertAction] = [],
		preferredAction: UIAlertAction? = nil
	) -> Self {
		let result = Self(title: title, message: message, preferredStyle: .alert)

		for action in actions {
			result.addAction(action)
		}

		result.preferredAction = preferredAction

		return result
	}
}
