//
//  HasConvenientAddAction.swift
//  Pomogator
//
//  Created by Anvipo on 10.01.2023.
//

import UIKit

@MainActor
protocol HasConvenientAddAction {}

extension HasConvenientAddAction where Self: UIControl {
	func add(action: @escaping (_ sender: Self) -> Void, for controlEvents: Event) {
		addAction(
			UIAction { uiAction in
				guard let sender = uiAction.sender as? Self else {
					assertionFailure("?")
					return
				}

				action(sender)
			},
			for: controlEvents
		)
	}
}

extension UIControl: HasConvenientAddAction {}
