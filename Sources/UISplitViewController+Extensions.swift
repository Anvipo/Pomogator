//
//  UISplitViewController+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 23.12.2022.
//

import UIKit

extension UISplitViewController {
	private typealias EmptyDetailVC = UIViewController

	var primaryVC: UIViewController? {
		guard !viewControllers.isEmpty else {
			assertionFailure("?")
			return nil
		}

		let possiblePrimaryVC = viewControllers[0]

		if let primaryNC = possiblePrimaryVC as? UINavigationController {
			return primaryNC.topViewController
		} else {
			return possiblePrimaryVC
		}
	}

	var detailVC: UIViewController? {
		guard viewControllers.count == 2 else {
			return nil
		}

		let possibleDetailVC = viewControllers[1] as UIResponder

		if let detailNC = possibleDetailVC as? UINavigationController {
			return detailNC.topViewController
		} else if possibleDetailVC is EmptyDetailVC {
			return nil
		} else {
			assertionFailure("?")
			return nil
		}
	}

	func showDetailVC(_ viewController: UIViewController) {
		showDetailViewController(viewController, sender: nil)
	}

	func hideDetailVC() {
		showDetailViewController(EmptyDetailVC(), sender: nil)
	}
}
