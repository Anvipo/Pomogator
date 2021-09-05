//
//  BaseNavigationController.swift
//  App
//
//  Created by Anvipo on 06.02.2023.
//

import UIKit

@MainActor
class BaseNavigationController: UINavigationController {
	private(set) var isViewVisible: Bool

	var shouldAnimate: Bool {
		if UIAccessibility.isReduceMotionEnabled {
			return UIAccessibility.prefersCrossFadeTransitions
		}

		return isViewVisible
	}

	init() {
		isViewVisible = false
		super.init(nibName: nil, bundle: nil)
		navigationBar.tintColor = ColorStyle.brand.color
	}

	override init(rootViewController: UIViewController) {
		isViewVisible = false
		super.init(rootViewController: rootViewController)
		navigationBar.tintColor = ColorStyle.brand.color
	}

	// swiftlint:disable unused_parameter
	@available(*, unavailable)
	override init(nibName: String?, bundle: Bundle?) {
		fatalError("init(nibName:bundle:) has not been implemented")
	}

	@available(*, unavailable)
	override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
		fatalError("init(navigationBarClass:toolbarClass:) has not been implemented")
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// swiftlint:enable unused_parameter

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		isViewVisible = true
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		isViewVisible = false
	}

	override func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
		super.present(viewControllerToPresent, animated: animated && shouldAnimate, completion: completion)
	}

	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		super.pushViewController(viewController, animated: animated && shouldAnimate)
	}

	@discardableResult
	override func popViewController(animated: Bool) -> UIViewController? {
		super.popViewController(animated: animated && shouldAnimate)
	}

	// swiftlint:disable discouraged_optional_collection
	@discardableResult
	override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
		super.popToViewController(viewController, animated: animated && shouldAnimate)
	}

	@discardableResult
	override func popToRootViewController(animated: Bool) -> [UIViewController]? {
		super.popToRootViewController(animated: animated && shouldAnimate)
	}
	// swiftlint:enable discouraged_optional_collection
}

extension BaseNavigationController {
	var topVC: BaseVC? {
		guard let topViewController else {
			assertionFailure("?")
			return nil
		}

		let topVC: BaseVC
		if let topNC = topViewController as? BaseNavigationController, let _topVC = topNC.topVC {
			topVC = _topVC
		} else if let _topVC = topViewController as? BaseVC {
			topVC = _topVC
		} else {
			assertionFailure("?")
			return nil
		}

		if let presentedViewController = topVC.presentedViewController {
			guard let presentedVC = presentedViewController as? BaseVC else {
				return topVC
			}

			return presentedVC
		}

		return topVC
	}
}
