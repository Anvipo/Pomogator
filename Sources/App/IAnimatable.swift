//
//  IAnimatable.swift
//  App
//
//  Created by Anvipo on 28.01.2023.
//

import UIKit

protocol IAnimatable {}

extension IAnimatable where Self: UIView {
	func animate(
		duration: TimeInterval,
		options: UIView.AnimationOptions = [.transitionCrossDissolve, .curveEaseInOut],
		delay: TimeInterval = 0,
		animations: @escaping (_ onView: Self) -> Void,
		completion: ((_ isFinished: Bool) -> Void)? = nil
	) {
		if duration.isZero ||
		   !isAddedToWindow ||
		   (UIAccessibility.isReduceMotionEnabled && !UIAccessibility.prefersCrossFadeTransitions) {
			animations(self)
			completion?(true)
			return
		}

		var options = options

		if UIAccessibility.isReduceMotionEnabled && UIAccessibility.prefersCrossFadeTransitions {
			options.remove([
				.transitionCurlUp,
				.transitionCurlDown,
				.transitionFlipFromLeft,
				.transitionFlipFromTop,
				.transitionFlipFromRight,
				.transitionFlipFromBottom
			])
			if !options.contains(.transitionCrossDissolve) {
				options.insert(.transitionCrossDissolve)
			}
		}

		Self.animate(
			withDuration: duration,
			delay: delay,
			options: options,
			animations: { animations(self) },
			completion: completion
		)
	}
}

extension UIView: IAnimatable {}
