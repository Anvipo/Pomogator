//
//  UIWindow+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 10.01.2023.
//

import UIKit

extension UIWindow {
	var snapshot: UIImage {
		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		format.scale = screen.scale

		return UIGraphicsImageRenderer(
			size: bounds.size,
			format: format
		).image { _ in
			drawHierarchy(in: frame, afterScreenUpdates: false)
		}
	}
}

extension UIWindow {
	var topPresentedVC: UIViewController? {
		var topVC = rootViewController?.topPresentedVC

		if let navigationController = topVC as? UINavigationController {
			topVC = navigationController.topViewController ?? navigationController
		}

		if let tabBarController = topVC as? UITabBarController {
			let selectedViewController = tabBarController.selectedViewController

			if let navigationController = selectedViewController as? UINavigationController {
				topVC = navigationController.topViewController
			} else if selectedViewController != nil {
				topVC = selectedViewController
			}
		}

		return topVC
	}
}
