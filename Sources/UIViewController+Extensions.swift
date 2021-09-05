//
//  UIViewController+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 23.12.2022.
//

import UIKit

extension UIViewController {
	var isShownFirstTime: Bool {
		isBeingPresented || isMovingToParent || (navigationController?.isShownFirstTime ?? false)
	}

	var isPresentedModally: Bool {
		presentingViewController != nil
	}

	var topPresentedVC: UIViewController? {
		var vc: UIViewController? = self
		while let presentedVC = vc?.presentedViewController {
			vc = presentedVC
		}
		return vc
	}

	func wrappedInModalNavigation(presentationStyle: UIModalPresentationStyle = .formSheet) -> UINavigationController {
		let controller = wrappedInPlainNavigation()
		controller.modalPresentationStyle = presentationStyle
		return controller
	}

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

	func add(child: UIViewController) {
		addChild(child)
		view.addSubview(child.view)
		child.view.translatesAutoresizingMaskIntoConstraints = false
		child.didMove(toParent: self)
	}

	func removeFromParentViewController() {
		if parent == nil {
			return
		}

		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
}
