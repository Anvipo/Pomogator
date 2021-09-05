//
//  UIView+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

extension UIView {
	var isVisible: Bool {
		window != nil
	}

	func bounds(inCoordinateSpaceOf view: UIView) -> CGRect {
		convert(bounds, to: view)
	}

	func layoutViewIfNeededOrSetNeedsLayout() {
		if isVisible {
			layoutIfNeeded()
		} else {
			setNeedsLayout()
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

extension Array where Element: UIView {
	// swiftlint:disable:next function_body_length
	func makeSameAnchorConstraints(
		toVerticalPagingScrollView scrollView: UIScrollView,
		spacing: CGFloat = 0,
		info: UIView.ConstraintsMakeInfo = .edgesEqual()
	) -> [NSLayoutConstraint] {
		if !scrollView.isPagingEnabled {
			assertionFailure("?")
			return []
		}

		if isEmpty {
			assertionFailure("?")
			return []
		}

		if count == 1 {
			// swiftlint:disable:next force_unwrapping
			return first!.makeSameAnchorConstraints(to: scrollView, info: info)
		}

		var result = [NSLayoutConstraint]()
		for (subviewIndex, subview) in enumerated() {
			var verticalConstraints = [NSLayoutConstraint]()
			switch subviewIndex {
			case firstElementIndex:
				guard let topConstraintMakeInfo = info.top else {
					assertionFailure("?")
					return []
				}

				let topToScrollViewConstraint = topConstraintMakeInfo.constraint(
					firstAnchor: subview.topAnchor,
					secondAnchor: scrollView.contentLayoutGuide.topAnchor
				)
				verticalConstraints.append(topToScrollViewConstraint)

				let interVerticalConstraint = subview.bottomAnchor.constraint(
					equalTo: self[subviewIndex + 1].topAnchor,
					constant: spacing
				)
				verticalConstraints.append(interVerticalConstraint)

			case lastElementIndex:
				guard let bottomConstraintMakeInfo = info.bottom else {
					assertionFailure("?")
					return []
				}

				let bottomToScrollViewConstraint = bottomConstraintMakeInfo.constraint(
					firstAnchor: subview.bottomAnchor,
					secondAnchor: scrollView.contentLayoutGuide.bottomAnchor
				)
				verticalConstraints.append(bottomToScrollViewConstraint)

			default:
				let interVerticalConstraint = subview.bottomAnchor.constraint(
					equalTo: self[subviewIndex + 1].topAnchor,
					constant: spacing
				)
				verticalConstraints.append(interVerticalConstraint)
			}

			result += verticalConstraints + [
				subview.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
				subview.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

				subview.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
				subview.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
			]
		}

		return result
	}

	// swiftlint:disable:next function_body_length
	func makeSameAnchorConstraints(
		toHorizontalPagingScrollView scrollView: UIScrollView,
		spacing: CGFloat = 0,
		info: UIView.ConstraintsMakeInfo = .edgesEqual()
	) -> [NSLayoutConstraint] {
		if !scrollView.isPagingEnabled {
			assertionFailure("?")
			return []
		}

		if isEmpty {
			assertionFailure("?")
			return []
		}

		if count == 1 {
			// swiftlint:disable:next force_unwrapping
			return first!.makeSameAnchorConstraints(to: scrollView, info: info)
		}

		var result = [NSLayoutConstraint]()
		for (subviewIndex, subview) in enumerated() {
			var horizontalConstraints = [NSLayoutConstraint]()
			switch subviewIndex {
			case firstElementIndex:
				guard let leadingConstraintMakeInfo = info.leading else {
					assertionFailure("?")
					return []
				}

				let leadingToScrollViewConstraint = leadingConstraintMakeInfo.constraint(
					firstAnchor: subview.leadingAnchor,
					secondAnchor: scrollView.contentLayoutGuide.leadingAnchor
				)
				horizontalConstraints.append(leadingToScrollViewConstraint)

				let interHorizontalConstraint = subview.trailingAnchor.constraint(
					equalTo: self[subviewIndex + 1].leadingAnchor,
					constant: spacing
				)
				horizontalConstraints.append(interHorizontalConstraint)

			case lastElementIndex:
				guard let trailingConstraintMakeInfo = info.trailing else {
					assertionFailure("?")
					return []
				}

				let trailingToScrollViewConstraint = trailingConstraintMakeInfo.constraint(
					firstAnchor: subview.trailingAnchor,
					secondAnchor: scrollView.contentLayoutGuide.trailingAnchor
				)
				horizontalConstraints.append(trailingToScrollViewConstraint)

			default:
				let interHorizontalConstraint = subview.trailingAnchor.constraint(
					equalTo: self[subviewIndex + 1].leadingAnchor,
					constant: spacing
				)
				horizontalConstraints.append(interHorizontalConstraint)
			}

			result += horizontalConstraints + [
				subview.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
				subview.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

				subview.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
				subview.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
			]
		}

		return result
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

// MARK: - Shadows extensions

extension UIView {
	func addDefaultShadow(
		shadowColor: UIColor,
		animationDuration: TimeInterval = 0
	) {
		let shadowPath = UIBezierPath(
			roundedRect: layer.bounds,
			cornerRadius: layer.cornerRadius
		)
		layer.apply(
			shadowParameters: .default(
				color: shadowColor.cgColor,
				path: shadowPath.cgPath
			),
			animationDuration: animationDuration
		)
	}

	func resetShadowParameters() {
		layer.apply(shadowParameters: .caDefault, animationDuration: 0)
	}
}

// MARK: - Corner radius extensions

extension UIView {
	func addDefaultCircleCorners() {
		layer.roundCornersToCircle(by: layer.bounds.size)
	}
}

// MARK: - Actual content extensions

extension UIView {
	func actualContentHeight(availableWidth: CGFloat) -> CGFloat {
		let targetSize = CGSize(
			width: availableWidth,
			height: Self.layoutFittingCompressedSize.height
		)
		let result = systemLayoutSizeFitting(
			targetSize,
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel
		)
		return result.height
	}

	func actualContentWidth(availableHeight: CGFloat) -> CGFloat {
		let targetSize = CGSize(
			width: Self.layoutFittingCompressedSize.width,
			height: availableHeight
		)
		let result = systemLayoutSizeFitting(
			targetSize,
			withHorizontalFittingPriority: .fittingSizeLevel,
			verticalFittingPriority: .required
		)
		return result.width
	}
}

// MARK: - Animations extension

extension UIView {
	func addFadeTransition(
		duration: TimeInterval = .defaultAnimationDuration,
		animations: (() -> Void)? = nil,
		completion: ((Bool) -> Void)? = nil
	) {
		Self.transition(
			with: self,
			duration: duration,
			options: .transitionCrossDissolve,
			animations: animations,
			completion: completion
		)
	}

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
