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

	static func actionSheet(
		title: String?,
		message: String?,
		actions: [UIAlertAction] = [],
		preferredAction: UIAlertAction? = nil
	) -> Self {
		let result = Self(title: title, message: message, preferredStyle: .actionSheet)

		for action in actions {
			result.addAction(action)
		}

		result.preferredAction = preferredAction

		return result
	}
}

extension UIAlertController {
	func addCancelAction(
		title: String,
		isPreferred: Bool = false,
		handler: ((UIAlertAction) -> Void)? = nil
	) {
		addAction(title: title, style: .cancel, isPreferred: isPreferred, handler: handler)
	}

	func addDefaultAction(
		title: String,
		isPreferred: Bool = false,
		handler: ((UIAlertAction) -> Void)? = nil
	) {
		addAction(title: title, style: .default, isPreferred: isPreferred, handler: handler)
	}

	func addDestructiveAction(
		title: String,
		isPreferred: Bool = false,
		handler: ((UIAlertAction) -> Void)? = nil
	) {
		addAction(title: title, style: .destructive, isPreferred: isPreferred, handler: handler)
	}
}

private extension UIAlertController {
	func addAction(
		title: String,
		style: UIAlertAction.Style,
		isPreferred: Bool,
		handler: ((UIAlertAction) -> Void)?
	) {
		let action = UIAlertAction(title: title, style: style, handler: handler)
		add(action: action, isPreferred: isPreferred)
	}

	func add(
		action: UIAlertAction,
		isPreferred: Bool
	) {
		addAction(action)

		if isPreferred {
			preferredAction = action
		}
	}
}
