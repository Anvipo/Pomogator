//
//  UIView+Extensions.swift
//  App
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

extension Array where Element: UIView {
	func firstViewOfType<V: UIView>() -> V? {
		first { $0 is V } as? V
	}
}

extension UIView {
	var firstResponder: UIView? {
		guard !isFirstResponder else {
			return self
		}

		for subview in subviews {
			if let firstResponder = subview.firstResponder {
				return firstResponder
			}
		}

		return nil
	}

	var isAddedToWindow: Bool {
		window != nil
	}

	var baseVC: BaseVC? {
		var responder: UIResponder? = self
		while let nextResponder = responder?.next {
			responder = nextResponder
			if let baseVC = responder as? BaseVC {
				return baseVC
			}
		}

		return nil
	}

	func setNeedsLayoutAndLayoutIfNeeded(checkVCVisibility: Bool = true) {
		setNeedsLayout()

		if isVisible(checkVCVisibility: checkVCVisibility) {
			layoutIfNeeded()
		}
	}

	func isVisible(checkVCVisibility: Bool = true) -> Bool {
		if checkVCVisibility, let baseVC {
			baseVC.isViewVisible
		} else {
			isAddedToWindow
		}
	}

	func layoutViewIfNeededOrSetNeedsLayout() {
		if isVisible() {
			layoutIfNeeded()
		} else {
			setNeedsLayout()
		}
	}

	func addPointerInteraction(delegate: UIPointerInteractionDelegate) {
		let pointerInteraction = UIPointerInteraction(delegate: delegate)
		addInteraction(pointerInteraction)
	}

	func firstSubviewOfType<V: UIView>() -> V? {
		subviews.firstViewOfType()
	}
}

// MAKE: - Constraints extension

extension UIView {
	func makeEqualSidesConstraintsWithInfo(
		side: CGFloat?
	) -> EqualSidesConstraintsWithInfo {
		EqualSidesConstraintsWithInfo(
			ratioConstraint: widthAnchor.constraint(equalTo: heightAnchor),
			sideConstraint: heightAnchor.constraint(equalToConstant: side ?? 0)
		)
	}

	func makeEdgeConstraintsEqualToSuperview(insets: NSDirectionalEdgeInsets = .zero) -> [NSLayoutConstraint] {
		makeEdgeConstraintsEqualToSuperviewWithInfo(insets: insets).onlyConstraints
	}

	func makeEdgeConstraintsEqualToSuperviewWithInfo(insets: NSDirectionalEdgeInsets = .zero) -> SameAnchorConstraintsWithInfo {
		guard let superview else {
			fatalError("?")
		}

		return makeSameAnchorConstraintsWithInfo(
			to: superview,
			info: .equal(
				leading: insets.leading,
				top: insets.top,
				trailing: insets.trailing,
				bottom: insets.bottom
			)
		)
	}

	func makeEdgeConstraintsEqualToSuperview(
		leading: CGFloat? = nil,
		top: CGFloat? = nil,
		trailing: CGFloat? = nil,
		bottom: CGFloat? = nil
	) -> [NSLayoutConstraint] {
		makeEdgeConstraintsEqualToSuperviewWithInfo(leading: leading, top: top, trailing: trailing, bottom: bottom).onlyConstraints
	}

	func makeEdgeConstraintsEqualToSuperviewWithInfo(
		leading: CGFloat? = nil,
		top: CGFloat? = nil,
		trailing: CGFloat? = nil,
		bottom: CGFloat? = nil
	) -> SameAnchorConstraintsWithInfo {
		guard let superview else {
			fatalError("?")
		}

		return makeSameAnchorConstraintsWithInfo(
			to: superview,
			info: .equal(leading: leading, top: top, trailing: trailing, bottom: bottom)
		)
	}

	func makeEdgeConstraintsEqualToSuperviewSafeArea(insets: NSDirectionalEdgeInsets = .zero) -> [NSLayoutConstraint] {
		makeEdgeConstraintsEqualToSuperviewSafeAreaWithInfo(insets: insets).onlyConstraints
	}

	func makeEdgeConstraintsEqualToSuperviewSafeAreaWithInfo(insets: NSDirectionalEdgeInsets = .zero) -> SameAnchorConstraintsWithInfo {
		guard let superview else {
			fatalError("?")
		}

		return makeSameAnchorConstraintsWithInfo(
			to: superview.safeAreaLayoutGuide,
			info: .equal(
				leading: insets.leading,
				top: insets.top,
				trailing: insets.trailing,
				bottom: insets.bottom
			)
		)
	}

	func makeEdgeConstraintsEqualToSuperviewSafeArea(
		leading: CGFloat? = nil,
		top: CGFloat? = nil,
		trailing: CGFloat? = nil,
		bottom: CGFloat? = nil
	) -> [NSLayoutConstraint] {
		makeEdgeConstraintsEqualToSuperviewSafeAreaWithInfo(
			leading: leading,
			top: top,
			trailing: trailing,
			bottom: bottom
		).onlyConstraints
	}

	func makeEdgeConstraintsEqualToSuperviewSafeAreaWithInfo(
		leading: CGFloat? = nil,
		top: CGFloat? = nil,
		trailing: CGFloat? = nil,
		bottom: CGFloat? = nil
	) -> SameAnchorConstraintsWithInfo {
		guard let superview else {
			fatalError("?")
		}

		return makeSameAnchorConstraintsWithInfo(
			to: superview.safeAreaLayoutGuide,
			info: .equal(leading: leading, top: top, trailing: trailing, bottom: bottom)
		)
	}
}

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
			leading: info.leading?.makeConstraint(firstAnchor: leadingAnchor, secondAnchor: layoutGuide.leadingAnchor),
			top: info.top?.makeConstraint(firstAnchor: topAnchor, secondAnchor: layoutGuide.topAnchor),
			trailing: info.trailing?.makeConstraint(firstAnchor: trailingAnchor, secondAnchor: layoutGuide.trailingAnchor),
			bottom: info.bottom?.makeConstraint(firstAnchor: bottomAnchor, secondAnchor: layoutGuide.bottomAnchor),
			centerY: info.centerY?.makeConstraint(firstAnchor: centerYAnchor, secondAnchor: layoutGuide.centerYAnchor),
			centerX: info.centerX?.makeConstraint(firstAnchor: centerXAnchor, secondAnchor: layoutGuide.centerXAnchor),
			width: info.width?.makeConstraint(firstAnchor: widthAnchor, secondAnchor: layoutGuide.widthAnchor),
			height: info.height?.makeConstraint(firstAnchor: heightAnchor, secondAnchor: layoutGuide.heightAnchor)
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
			leading: info.leading?.makeConstraint(firstAnchor: leadingAnchor, secondAnchor: view.leadingAnchor),
			top: info.top?.makeConstraint(firstAnchor: topAnchor, secondAnchor: view.topAnchor),
			trailing: info.trailing?.makeConstraint(firstAnchor: trailingAnchor, secondAnchor: view.trailingAnchor),
			bottom: info.bottom?.makeConstraint(firstAnchor: bottomAnchor, secondAnchor: view.bottomAnchor),
			centerY: info.centerY?.makeConstraint(firstAnchor: centerYAnchor, secondAnchor: view.centerYAnchor),
			centerX: info.centerX?.makeConstraint(firstAnchor: centerXAnchor, secondAnchor: view.centerXAnchor),
			width: info.width?.makeConstraint(firstAnchor: widthAnchor, secondAnchor: view.widthAnchor),
			height: info.height?.makeConstraint(firstAnchor: heightAnchor, secondAnchor: view.heightAnchor)
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

// MARK: - Wrap in view extensions

extension UIView {
	func wrappedInVerticalScrollView() -> UIScrollView {
		let scrollView = UIScrollView()
		scrollView.alwaysBounceVertical = true
		scrollView.addSubviewForConstraintsUse(self)
		NSLayoutConstraint.activate(
			makeSameAnchorConstraints(
				to: scrollView,
				info: .equal(leading: 0, top: 0, trailing: 0, bottom: 0, width: 0)
			)
		)
		return scrollView
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
}

// MARK: - Animations extension

extension UIView {
	static func animate(
		duration: TimeInterval,
		delay: TimeInterval = 0,
		options: UIView.AnimationOptions = [.curveEaseInOut, .transitionCrossDissolve],
		animations: @escaping () -> Void,
		completion: ((Bool) -> Void)? = nil
	) {
		if duration.isZero ||
		   (UIAccessibility.isReduceMotionEnabled && !UIAccessibility.prefersCrossFadeTransitions) {
			animations()
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
			animations: animations,
			completion: completion
		)
	}

	static func animate(
		eachAnimationDuration: TimeInterval,
		secondAnimationsRelativeStartTime: TimeInterval,
		delay: TimeInterval = 0,
		options: UIView.KeyframeAnimationOptions = [],
		firstAnimations: @escaping () -> Void,
		secondAnimations: @escaping () -> Void,
		completion: ((_ isFinished: Bool) -> Void)? = nil
	) {
		if eachAnimationDuration.isZero ||
		   (UIAccessibility.isReduceMotionEnabled && !UIAccessibility.prefersCrossFadeTransitions) {
			firstAnimations()
			secondAnimations()
			completion?(true)
			return
		}

		let animationsCount: TimeInterval = 2
		let relativeEachAnimationDuration = 1 / animationsCount // по сути, равен eachAnimationDuration (только в относительном значении)

		UIView.animateKeyframes(
			withDuration: eachAnimationDuration * animationsCount,
			delay: delay,
			options: options,
			animations: {
				UIView.addKeyframe(
					withRelativeStartTime: 0,
					relativeDuration: relativeEachAnimationDuration,
					animations: firstAnimations
				)

				UIView.addKeyframe(
					withRelativeStartTime: secondAnimationsRelativeStartTime * relativeEachAnimationDuration,
					relativeDuration: relativeEachAnimationDuration,
					animations: secondAnimations
				)
			},
			completion: completion
		)
	}

	static func fadeTransition(
		from fromView: UIView,
		to toView: UIView,
		duration: TimeInterval,
		animationsAlongWithToViewShowing: (() -> Void)? = nil,
		completion: ((_ isFinished: Bool) -> Void)? = nil
	) {
		if fromView.alpha == 0 &&
		   fromView.isHidden &&
		   toView.alpha == 1 &&
		   !toView.isHidden {
			return
		}

		Self.animate(
			eachAnimationDuration: duration,
			// на 94-ом проценте скрытия fromView
			// чтобы контенты не были видны в один момент времени
			secondAnimationsRelativeStartTime: 0.94,
			firstAnimations: {
				// выключаем прозрачность у fromView
				fromView.alpha = 0
			},
			secondAnimations: {
				// делаем toView видимой, что было видно её анимацию появления
				toView.isHidden = false
				// включаем прозрачность у toView
				toView.alpha = 1
				animationsAlongWithToViewShowing?()
			},
			completion: { isFinished in
				fromView.isHidden = true
				completion?(isFinished)
			}
		)
	}

	func fadeShow(
		duration: TimeInterval,
		additionalAnimations: (() -> Void)? = nil,
		completion: ((_ isFinished: Bool) -> Void)? = nil
	) {
		if alpha == 1 && !isHidden {
			return
		}

		if let parentStackView = superview as? UIStackView,
		   parentStackView.arrangedSubviews.contains(where: { !$0.isHidden && $0.alpha > 0 }) {
			fadeShowArrangedSubviewInStackView(
				duration: duration,
				additionalAnimations: additionalAnimations,
				completion: completion
			)
		} else {
			// убеждаемся, что superview закончила все отложенные layout-ы
			// иначе она может "скакать" во время layout-а этой вьюшки
			superview?.layoutViewIfNeededOrSetNeedsLayout()

			animate(
				duration: duration,
				animations: { view in
					view.isHidden = false
					additionalAnimations?()
					view.alpha = 1
				},
				completion: completion
			)
		}
	}

	func fadeHide(
		duration: TimeInterval,
		additionalAnimations: (() -> Void)? = nil,
		completion: ((_ isFinished: Bool) -> Void)? = nil
	) {
		if alpha == 0 && isHidden {
			return
		}

		if let parentStackView = superview as? UIStackView,
		   parentStackView.arrangedSubviews.contains(where: { !$0.isHidden && $0.alpha > 0 }) {
			fadeHideArrangedSubviewInStackView(
				duration: duration,
				additionalAnimations: additionalAnimations,
				completion: completion
			)
		} else {
			// убеждаемся, что superview закончила все отложенные layout-ы
			// иначе она может "скакать" во время layout-а этой вьюшки
			superview?.layoutViewIfNeededOrSetNeedsLayout()

			animate(
				duration: duration,
				animations: { view in
					view.alpha = 0
					additionalAnimations?()
				},
				completion: { [weak self] isFinished in
					self?.isHidden = true
					completion?(isFinished)
				}
			)
		}
	}
}

private extension UIView {
	func fadeShowArrangedSubviewInStackView(
		duration: TimeInterval,
		additionalAnimations: (() -> Void)? = nil,
		completion: ((_ isFinished: Bool) -> Void)? = nil
	) {
		if alpha == 1 && !isHidden {
			return
		}

		Self.animate(
			eachAnimationDuration: duration,
			// на 95-ом проценте раскрытия stack view
			// чтобы не было видно, как сабвью вылезает в неконечном размере
			secondAnimationsRelativeStartTime: 0.95,
			firstAnimations: { [weak self] in
				self?.isHidden = false
				// layout-им родительский stackview
				// чтобы анимация была красивее
				// (чтобы эта вьюшка не выезжала слева сверху и увеличивалась альфа)
				// (а плавно увеличивалась по высоте и увеличивалась альфа)
				self?.superview?.layoutViewIfNeededOrSetNeedsLayout()

				additionalAnimations?()
			},
			secondAnimations: { [weak self] in
				self?.alpha = 1
			},
			completion: completion
		)
	}

	func fadeHideArrangedSubviewInStackView(
		duration: TimeInterval,
		additionalAnimations: (() -> Void)? = nil,
		completion: ((_ isFinished: Bool) -> Void)? = nil
	) {
		if alpha == 0 && isHidden {
			return
		}

		Self.animate(
			eachAnimationDuration: duration,
			// на 96-ом проценте cкрытия сабвью
			// чтобы не было видно, как сабвью скрывается, уменьшаясь в размерах
			secondAnimationsRelativeStartTime: 0.96,
			firstAnimations: { [weak self] in
				self?.alpha = 0
			},
			secondAnimations: { [weak self] in
				self?.isHidden = true
				// layout-им родительский stackview
				// чтобы анимация была красивее
				// (чтобы эта вьюшка не уезжала влево вниз и уменьшалась альфа)
				// (а плавно уменьшалась по высоте и уменьшалась альфа)
				self?.superview?.layoutViewIfNeededOrSetNeedsLayout()

				additionalAnimations?()
			},
			completion: completion
		)
	}
}
