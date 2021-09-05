//
//  UISplitViewController+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 23.12.2022.
//

import UIKit

extension UISplitViewController {
	var hasNoDetailViewController: Bool {
		!hasDetailViewController
	}

	var hasDetailViewController: Bool {
		viewControllers.count == 2
	}

	var detailViewController: UIViewController? {
		if hasNoDetailViewController {
			return nil
		}

		return (viewControllers.last as? UINavigationController)?.viewControllers.first
	}

	func showDetailViewController(_ viewController: UIViewController) {
		showDetailViewController(viewController, sender: nil)
	}

	func hideDetailViewController(sender: Any? = nil) {
		showDetailViewController(UIViewController(), sender: sender)
	}
}
