//
//  AppTabBarController.swift
//  App
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class AppTabBarController: BaseTabBarController {
	private let transitionAnimationController: AppTabBarControllerTransitionAnimationController

	private weak var coordinator: AppCoordinator?

	override var selectedIndex: Int {
		didSet {
			coordinator?.didChangeTabIndex(to: selectedIndex)
		}
	}

	init(coordinator: AppCoordinator) {
		self.coordinator = coordinator
		transitionAnimationController = AppTabBarControllerTransitionAnimationController(
			transitionDuration: .defaultAnimationDuration
		)

		super.init()

		delegate = self

		coordinator.prepareDidChangeScreenFeedbackGenerator()

		registerForTraitPreferredContentSizeCategoryChanges()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let tap = UISwipeGestureRecognizer(target: self, action: #selector(didTap))
		tap.direction = [.up, .down, .left, .right]
		view.addGestureRecognizer(tap)
	}

	override func traitPreferredContentSizeCategoryDidChange(_ previousTraitCollection: UITraitCollection) {
		if !traitCollection.preferredContentSizeCategory.isAccessibilityCategory ||
		   !traitCollection.hasDifferentPreferredContentSizeCategory(comparedTo: previousTraitCollection) {
			return
		}

		for viewController in viewControllers ?? [] {
			guard let currentTabBarItemImage = viewController.tabBarItem.image,
				  let currentTabBarItemLargeImage = viewController.tabBarItem.largeContentSizeImage
			else {
				continue
			}

			let scaledTabBarItemImageSide = FontStyle.caption2.fontMetrics.scaledValue(for: currentTabBarItemImage.size.width)
			let resizedTabBarImage = try! currentTabBarItemLargeImage.proportionallyResized(to: .init(side: scaledTabBarItemImageSide))
			tabBarItem.largeContentSizeImage = resizedTabBarImage
		}
	}

	override func handle(
		presses: Set<UIPress>,
		event: UIPressesEvent?,
		superImplementation: HandlePressesClosure
	) {
		guard presses.count == 1,
			  let press = presses.first
		else {
			assertionFailure("?")
			superImplementation(presses, event)
			return
		}

		guard let pressedKey = press.key else {
			superImplementation(presses, event)
			return
		}

		switch pressedKey.keyCode {
		case .keyboard1:
			if press.phase == .ended && pressedKey.modifierFlags == .command {
				if selectedIndex != 0 && !transitionAnimationController.isTransitioning {
					selectedIndex = 0
				}
			}

		case .keyboard2:
			if press.phase == .ended && pressedKey.modifierFlags == .command {
				if selectedIndex != 1 && !transitionAnimationController.isTransitioning {
					selectedIndex = 1
				}
			}

		default:
			superImplementation(presses, event)
		}
	}

	override func handle(
		touches: Set<UITouch>,
		event: UIEvent?,
		superImplementation: HandleTouchesClosure
	) {
		guard touches.allSatisfy({ $0.phase == .began }) else {
			superImplementation(touches, event)
			return
		}

		coordinator?.prepareDidChangeScreenFeedbackGenerator()
	}

	// swiftlint:disable:next unused_parameter
	override func tabBar(_: UITabBar, didSelect: UITabBarItem) {
		coordinator?.prepareDidChangeScreenFeedbackGenerator()
	}
}

// swiftlint:disable unused_parameter
extension AppTabBarController: UITabBarControllerDelegate {
	func tabBarController(_: UITabBarController, shouldSelect: UIViewController) -> Bool {
		!transitionAnimationController.isTransitioning
	}

	func tabBarController(_: UITabBarController, didSelect: UIViewController) {
		coordinator?.triggerDidChangeScreenFeedbackGenerator()
		coordinator?.didChangeTabIndex(to: selectedIndex)
	}

	func tabBarController(
		_: UITabBarController,
		animationControllerForTransitionFrom: UIViewController,
		to: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		transitionAnimationController
	}
}
// swiftlint:enable unused_parameter

extension AppTabBarController: IRestorable {
	func saveUserActivityForRestore(to userActivity: NSUserActivity) {
		userActivity.restoredTabIndex = selectedIndex
	}

	func restore(from userActivity: NSUserActivity) {
		guard let restoredTabIndex = userActivity.restoredTabIndex else {
			assertionFailure("?")
			return
		}

		if selectedIndex != restoredTabIndex {
			selectedIndex = restoredTabIndex
		}
	}
}

private extension AppTabBarController {
	@objc
	func didTap() {
		coordinator?.prepareDidChangeScreenFeedbackGenerator()
	}
}

private extension String {
	static var restoredTabIndexKey: Self {
		"restoredTabIndex"
	}
}

private extension NSUserActivity {
	var restoredTabIndex: Int? {
		get {
			guard let userInfo,
				  let restoredTabIndexRawValue = userInfo[String.restoredTabIndexKey],
				  let restoredTabIndex = restoredTabIndexRawValue as? Int
			else {
				return nil
			}

			return restoredTabIndex
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredTabIndexKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredTabIndexKey: newValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}
}
