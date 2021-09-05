//
//  UIView+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

extension UIView {
	var isAddedToWindow: Bool {
		window != nil
	}

	func layoutViewIfNeededOrSetNeedsLayout() {
		if isAddedToWindow {
			layoutIfNeeded()
		} else {
			setNeedsLayout()
		}
	}

	func animateIfNeeded(
		animationDuration: TimeInterval = .defaultAnimationDuration,
		animations: @escaping () -> Void
	) {
		if isAddedToWindow {
			Self.animate(withDuration: animationDuration, animations: animations)
		} else {
			animations()
		}
	}
}

// MAKE: - Constraints extension

extension UIView {
	func makeSameAnchorConstraints(
		to layoutGuide: UILayoutGuide,
		info: ConstraintsMakeInfo
	) -> [NSLayoutConstraint] {
		makeSameAnchorConstraintsWithInfo(to: layoutGuide, info: info).onlyConstraints
	}

	func makeSameAnchorConstraintsWithInfo(
		to layoutGuide: UILayoutGuide,
		info: ConstraintsMakeInfo
	) -> SameAnchorConstraintsWithInfo {
		SameAnchorConstraintsWithInfo(
			leading: info.leading?.constraint(firstAnchor: leadingAnchor, secondAnchor: layoutGuide.leadingAnchor),
			top: info.top?.constraint(firstAnchor: topAnchor, secondAnchor: layoutGuide.topAnchor),
			trailing: info.trailing?.constraint(firstAnchor: trailingAnchor, secondAnchor: layoutGuide.trailingAnchor),
			bottom: info.bottom?.constraint(firstAnchor: bottomAnchor, secondAnchor: layoutGuide.bottomAnchor),
			centerY: info.centerY?.constraint(firstAnchor: centerYAnchor, secondAnchor: layoutGuide.centerYAnchor),
			centerX: info.centerX?.constraint(firstAnchor: centerXAnchor, secondAnchor: layoutGuide.centerXAnchor),
			width: info.width?.constraint(firstAnchor: widthAnchor, secondAnchor: layoutGuide.widthAnchor),
			height: info.height?.constraint(firstAnchor: heightAnchor, secondAnchor: layoutGuide.heightAnchor)
		)
	}

	func makeSameAnchorConstraints(
		to view: UIView,
		info: ConstraintsMakeInfo
	) -> [NSLayoutConstraint] {
		makeSameAnchorConstraintsWithInfo(to: view, info: info).onlyConstraints
	}

	func makeSameAnchorConstraintsWithInfo(
		to view: UIView,
		info: ConstraintsMakeInfo
	) -> SameAnchorConstraintsWithInfo {
		SameAnchorConstraintsWithInfo(
			leading: info.leading?.constraint(firstAnchor: leadingAnchor, secondAnchor: view.leadingAnchor),
			top: info.top?.constraint(firstAnchor: topAnchor, secondAnchor: view.topAnchor),
			trailing: info.trailing?.constraint(firstAnchor: trailingAnchor, secondAnchor: view.trailingAnchor),
			bottom: info.bottom?.constraint(firstAnchor: bottomAnchor, secondAnchor: view.bottomAnchor),
			centerY: info.centerY?.constraint(firstAnchor: centerYAnchor, secondAnchor: view.centerYAnchor),
			centerX: info.centerX?.constraint(firstAnchor: centerXAnchor, secondAnchor: view.centerXAnchor),
			width: info.width?.constraint(firstAnchor: widthAnchor, secondAnchor: view.widthAnchor),
			height: info.height?.constraint(firstAnchor: heightAnchor, secondAnchor: view.heightAnchor)
		)
	}
}

// MARK: - Hierarchies extensions

extension UIView {
	func addSubviewsForConstraintsUse(_ subviews: [UIView]) {
		for subview in subviews {
			addSubviewForConstraintsUse(subview)
		}
	}

	func addSubviewForConstraintsUse(_ subview: UIView) {
		addSubview(subview)
		subview.translatesAutoresizingMaskIntoConstraints = false
	}
}

// MARK: - Animations extension

extension UIView {
	func set(
		backgroundColor: UIColor?,
		animated: Bool,
		completion: ((Bool) -> Void)? = nil
	) {
		let animations: () -> Void = { [weak self] in
			self?.backgroundColor = backgroundColor
		}

		set(changeValueClosure: animations, animated: animated, completion: completion)
	}

	func set(
		isHidden: Bool,
		animated: Bool,
		additionalAnimations: (() -> Void)? = nil,
		completion: ((Bool) -> Void)? = nil
	) {
		if !isHidden {
			// если надо показать, то выключаем isHidden, а потом плавно включится alpha
			self.isHidden = false
		}
		let animations: () -> Void = { [weak self] in
			self?.alpha = isHidden ? 0 : 1
			additionalAnimations?()
		}
		let fullCompletion: (Bool) -> Void = { [weak self] isFinished in
			self?.isHidden = isHidden
			completion?(isFinished)
		}

		set(changeValueClosure: animations, animated: animated, completion: fullCompletion)
	}

	private func set(
		changeValueClosure: @escaping () -> Void,
		animated: Bool,
		completion: ((Bool) -> Void)? = nil
	) {
		if animated {
			setAnimated(animations: changeValueClosure, completion: completion)
		} else {
			changeValueClosure()
			completion?(true)
		}
	}

	private func setAnimated(
		duration: TimeInterval = .defaultAnimationDuration,
		animations: @escaping () -> Void,
		completion: ((Bool) -> Void)? = nil
	) {
		Self.animate(
			withDuration: duration,
			delay: 0,
			options: [
				.allowUserInteraction,
				.beginFromCurrentState,
				.transitionCrossDissolve
			],
			animations: animations,
			completion: completion
		)
	}
}
