//
//  AppTabBarController.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class AppTabBarController: UITabBarController {
	private let didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator

	init(didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator) {
		self.didChangeScreenFeedbackGenerator = didChangeScreenFeedbackGenerator

		super.init(nibName: nil, bundle: nil)

		delegate = self

		didChangeScreenFeedbackGenerator.prepare()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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

	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		didChangeScreenFeedbackGenerator.impactOccurred()
	}
}

extension AppTabBarController: UITabBarControllerDelegate {
	func tabBarController(
		_ tabBarController: UITabBarController,
		animationControllerForTransitionFrom fromVC: UIViewController,
		to toVC: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		AppTabBarControllerTransitionAnimationController(transitionDuration: .defaultAnimationDuration)
	}
}

private extension AppTabBarController {
	@objc
	func didTap() {
		didChangeScreenFeedbackGenerator.prepare()
	}
}
