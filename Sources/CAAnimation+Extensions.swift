//
//  CAAnimation+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 10.01.2023.
//

import QuartzCore

extension CABasicAnimation {
	static func opacityPulseAnimation(
		fromAlpha: CGFloat,
		toAlpha: CGFloat,
		duration: CFTimeInterval,
		repeatCount: Float
	) -> Self {
		basicAnimation(
			keyPath: \.opacity,
			fromValue: Float(fromAlpha),
			toValue: Float(toAlpha),
			autoreverses: true,
			duration: duration,
			repeatCount: repeatCount,
			timingFunction: .easeIn
		)
	}
}

extension CAAnimation {
	static func animation(
		autoreverses: Bool,
		duration: CFTimeInterval,
		repeatCount: Float,
		timingFunction: CAMediaTimingFunction?
	) -> Self {
		let result = Self()

		result.autoreverses = autoreverses
		result.duration = duration
		result.repeatCount = repeatCount
		result.timingFunction = timingFunction

		return result
	}
}

extension CAPropertyAnimation {
	static func propertyAnimation<Value>(
		autoreverses: Bool,
		duration: CFTimeInterval,
		keyPath: WritableKeyPath<CALayer, Value>,
		repeatCount: Float,
		timingFunction: CAMediaTimingFunction?
	) -> Self {
		let result = Self.animation(
			autoreverses: autoreverses,
			duration: duration,
			repeatCount: repeatCount,
			timingFunction: timingFunction
		)

		let keyString = NSExpression(forKeyPath: keyPath).keyPath
		result.keyPath = keyString

		return result
	}
}

extension CATransition {
	static func transition(
		autoreverses: Bool,
		duration: CFTimeInterval,
		repeatCount: Float,
		timingFunction: CAMediaTimingFunction?,
		type: CATransitionType
	) -> Self {
		let result = Self.animation(
			autoreverses: autoreverses,
			duration: duration,
			repeatCount: repeatCount,
			timingFunction: timingFunction
		)

		result.type = type

		return result
	}
}

extension CABasicAnimation {
	// swiftlint:disable:next function_parameter_count
	static func basicAnimation<Value>(
		keyPath: WritableKeyPath<CALayer, Value>,
		fromValue: Value,
		toValue: Value,
		autoreverses: Bool,
		duration: CFTimeInterval,
		repeatCount: Float,
		timingFunction: CAMediaTimingFunction?
	) -> Self {
		let result = Self.propertyAnimation(
			autoreverses: autoreverses,
			duration: duration,
			keyPath: keyPath,
			repeatCount: repeatCount,
			timingFunction: timingFunction
		)

		result.fromValue = fromValue
		result.toValue = toValue

		return result
	}
}
