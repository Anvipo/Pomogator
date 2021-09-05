//
//  UIViewController+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 23.12.2022.
//

import UIKit

extension UIViewController {
	func wrappedInPlainNavigation(tintColor: UIColor = Color.brand.uiColor) -> UINavigationController {
		if let self = self as? UINavigationController {
			assertionFailure(
				"\(self.viewControllers.first?.debugDescription ?? "") был обернут в UINavigationController более одного раза"
			)
			return self
		} else {
			let navigationController = UINavigationController(rootViewController: self)
			navigationController.navigationBar.tintColor = tintColor
			return navigationController
		}
	}
}
