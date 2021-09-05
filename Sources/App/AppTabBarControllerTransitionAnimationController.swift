//
//  AppTabBarControllerTransitionAnimationController.swift
//  App
//
//  Created by Anvipo on 08.01.2023.
//

import UIKit

final class AppTabBarControllerTransitionAnimationController: NSObject {
	private let transitionDuration: TimeInterval

	var isTransitioning = false

	init(transitionDuration: TimeInterval) {
		self.transitionDuration = transitionDuration
	}
}

extension AppTabBarControllerTransitionAnimationController: UIViewControllerAnimatedTransitioning {
	func transitionDuration(
		using transitionContext: UIViewControllerContextTransitioning?
	) -> TimeInterval {
		if transitionContext?.containerView.isAddedToWindow == false ||
		   transitionContext?.isAnimated == false ||
		   (UIAccessibility.isReduceMotionEnabled && !UIAccessibility.prefersCrossFadeTransitions) {
			return 0
		}

		return transitionDuration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		if isTransitioning {
			return
		}

		guard let fromVC = transitionContext.viewController(forKey: .from),
			  let toVC = transitionContext.viewController(forKey: .to)
		else {
			assertionFailure("?")
			return
		}

		let transitionDuration = transitionDuration(using: transitionContext)

		if transitionDuration.isZero {
			transitionContext.containerView.addSubview(toVC.view)
			transitionContext.completeTransition(true)
			isTransitioning = false
			return
		}

		isTransitioning = true

		UIView.transition(
			from: fromVC.view,
			to: toVC.view,
			duration: transitionDuration,
			options: [.curveEaseInOut, .transitionCrossDissolve]
		) { [weak self] isFinished in
			transitionContext.completeTransition(isFinished)
			self?.isTransitioning = false
		}
	}
}
