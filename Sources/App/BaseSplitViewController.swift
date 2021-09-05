//
//  BaseSplitViewController.swift
//  App
//
//  Created by Anvipo on 05.02.2023.
//

import UIKit

@MainActor
class BaseSplitViewController: UISplitViewController {
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
	}

	// swiftlint:disable unused_parameter
	@available(*, unavailable)
	override init(style: UISplitViewController.Style) {
		fatalError("init(style:) has not been implemented")
	}

	@available(*, unavailable)
	override init(nibName: String?, bundle: Bundle?) {
		fatalError("init(nibName:bundle:) has not been implemented")
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// swiftlint:enable unused_parameter

	override func viewDidLoad() {
		super.viewDidLoad()
		view.tintColor = ColorStyle.brand.color
	}

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

	override final func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesBegan(_:with:))
	}

	override final func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesChanged(_:with:))
	}

	override final func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesEnded(_:with:))
	}

	override final func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesCancelled(_:with:))
	}

	func handle(
		presses: Set<UIPress>,
		event: UIPressesEvent?,
		superImplementation: HandlePressesClosure
	) {
		if let topVC {
			topVC.handle(presses: presses, event: event, superImplementation: superImplementation)
		} else {
			assertionFailure("?")
		}
	}
}

extension BaseSplitViewController {
	var topVC: BaseVC? {
		guard let topViewController = viewControllers.last else {
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
