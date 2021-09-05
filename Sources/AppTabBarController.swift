//
//  AppTabBarController.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class AppTabBarController: BaseTabBarController {
	private let didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator

	private weak var output: IAppTabBarControllerOutput?

	override var selectedIndex: Int {
		didSet {
			output?.didChangeTabIndex(to: selectedIndex)
		}
	}

	init(
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		output: IAppTabBarControllerOutput
	) {
		self.didChangeScreenFeedbackGenerator = didChangeScreenFeedbackGenerator
		self.output = output

		super.init()

		delegate = self

		didChangeScreenFeedbackGenerator.prepare()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let tap = UISwipeGestureRecognizer(target: self, action: #selector(didTap))
		tap.direction = [.up, .down, .left, .right]
		view.addGestureRecognizer(tap)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		didChangeScreenFeedbackGenerator.prepare()
	}
}

extension AppTabBarController: UITabBarControllerDelegate {
	func tabBarController(_: UITabBarController, didSelect viewController: UIViewController) {
		didChangeScreenFeedbackGenerator.impactOccurred()

		output?.didChangeTabIndex(to: selectedIndex)
	}

	func tabBarController(
		_: UITabBarController,
		animationControllerForTransitionFrom: UIViewController,
		to: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		AppTabBarControllerTransitionAnimationController(transitionDuration: .defaultAnimationDuration)
	}
}

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
		didChangeScreenFeedbackGenerator.prepare()
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
