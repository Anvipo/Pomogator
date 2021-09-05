//
//  AppTabBarControllerTransitionAnimationController.swift
//  Pomogator
//
//  Created by Anvipo on 08.01.2023.
//

import UIKit

final class AppTabBarControllerTransitionAnimationController: NSObject {
	private let transitionDuration: TimeInterval

	init(transitionDuration: TimeInterval) {
		self.transitionDuration = transitionDuration
	}
}

extension AppTabBarControllerTransitionAnimationController: UIViewControllerAnimatedTransitioning {
	func transitionDuration(
		using transitionContext: UIViewControllerContextTransitioning?
	) -> TimeInterval {
		transitionDuration
	}

	func animateTransition(
		using transitionContext: UIViewControllerContextTransitioning
	) {
		guard let fromVC = transitionContext.viewController(forKey: .from),
			  let toVC = transitionContext.viewController(forKey: .to)
		else {
			return
		}

		let animationOption: UIView.AnimationOptions = fromVC.tabBarItem.tag > toVC.tabBarItem.tag
		? .transitionFlipFromLeft
		: .transitionFlipFromRight

		UIView.transition(
			from: fromVC.view,
			to: toVC.view,
			duration: transitionDuration(using: transitionContext),
			options: [.curveEaseInOut, animationOption]
		) { _ in
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}
	}
}
