//
//  CALayer+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import QuartzCore

// MARK: - Shadows extensions

extension CALayer {
	func apply(shadowParameters: ShadowParameters, animationDuration: TimeInterval) {
		if animationDuration.isZero {
			shadowColor = shadowParameters.color
			shadowOffset = shadowParameters.offset
			shadowOpacity = shadowParameters.opacity
			shadowPath = shadowParameters.path
			shadowRadius = shadowParameters.radius
		} else {
			animate(keyPath: \.shadowColor, to: shadowParameters.color, duration: animationDuration)
			animate(keyPath: \.shadowOffset, to: shadowParameters.offset, duration: animationDuration)
			animate(keyPath: \.shadowOpacity, to: shadowParameters.opacity, duration: animationDuration)
			animate(keyPath: \.shadowPath, to: shadowParameters.path, duration: animationDuration)
			animate(keyPath: \.shadowRadius, to: shadowParameters.radius, duration: animationDuration)
		}
	}
}

// MARK: - Corner radius extensions

extension CALayer {
	func roundCornersToCircle(by size: CGSize) {
		cornerRadius = min(size.width, size.height) / 2
	}

	func addDefaultCircleCorners() {
		roundCornersToCircle(by: bounds.size)
	}

	func resetCornerRadius() {
		masksToBounds = false
		cornerRadius = 0
	}
}

// MARK: - Animations extensions

extension CALayer {
	func animate<Value>(
		keyPath: WritableKeyPath<CALayer, Value>,
		to value: Value,
		duration: TimeInterval
	) {
		let basicAnimation = CABasicAnimation.basicAnimation(
			keyPath: keyPath,
			fromValue: self[keyPath: keyPath],
			toValue: value,
			autoreverses: false,
			duration: duration,
			repeatCount: 0,
			timingFunction: nil
		)
		add(basicAnimation, forKey: basicAnimation.keyPath)

		var theLayer = self
		theLayer[keyPath: keyPath] = value
	}

	func addAnimatedTransition(
		type: CATransitionType = .fade,
		duration: CFTimeInterval = .defaultAnimationDuration,
		timingFunction: CAMediaTimingFunction = .default,
		animationName: String = "Pomogator.AnimatedTransition"
	) {
		let transition = CATransition.transition(
			autoreverses: false,
			duration: duration,
			repeatCount: 0,
			timingFunction: timingFunction,
			type: type
		)

		add(transition, forKey: animationName)
	}
}
