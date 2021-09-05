//
//  BaseTableVCWithSafeAreadButtons.swift
//  App
//
//  Created by Anvipo on 14.07.2024.
//

import UIKit

class BaseTableVCWithSafeAreadButtons<
	SectionIdentifierType: Hashable & Sendable,
	ItemIdentifierType: Hashable & Sendable
>: BaseTableVC<SectionIdentifierType, ItemIdentifierType> {
	private(set) var buttonsView: ButtonsView!

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpConstraints()
		setUpUI()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setUpContentScrollViewBottomInset(isButtonsViewVisible: isButtonsViewVisible)
	}

	func shouldAdjustContentScrollViewBottomInset() -> Bool {
		contentScrollViewToAdjustBottomInset().isVisible()
	}

	func contentScrollViewToAdjustBottomInset() -> UIScrollView {
		tableView
	}

	// swiftlint:disable:next unused_parameter
	func adjust(contentScrollView: UIScrollView, bottomInset: CGFloat, isButtonsViewVisible: Bool) {
		contentScrollView.contentInset.bottom = bottomInset
		contentScrollView.verticalScrollIndicatorInsets.bottom = bottomInset
	}
}

extension BaseTableVCWithSafeAreadButtons {
	var isButtonsViewVisible: Bool {
		!buttonsView.isHidden
	}

	func setUp(buttons: [Button]) {
		buttonsView = try! ButtonsView(buttons: buttons)

		view.addSubviewForConstraintsUse(buttonsView)
		NSLayoutConstraint.activate(buttonsView.makeEdgeConstraintsEqualToSuperview(leading: 0, trailing: 0, bottom: 0))
	}

	func show(button: Button) {
		if buttonsView.isHidden {
			button.fadeShow(duration: 0)

			buttonsView.fadeShow(duration: defaultAnimationDuration) { [weak self] in
				self?.setUpContentScrollViewBottomInset(isButtonsViewVisible: true)
			}
		} else {
			button.fadeShow(duration: defaultAnimationDuration)
		}
	}

	func hide(button: Button) {
		if buttonsView.areOtherButtonsHidden(button: button) {
			buttonsView.fadeHide(
				duration: defaultAnimationDuration,
				additionalAnimations: { [weak self] in
					self?.setUpContentScrollViewBottomInset(isButtonsViewVisible: false)
				},
				completion: { _ in
					button.fadeHide(duration: 0)
				}
			)
		} else {
			button.fadeHide(duration: defaultAnimationDuration)
		}
	}

	func setUpContentScrollViewBottomInset(isButtonsViewVisible: Bool) {
		if !shouldAdjustContentScrollViewBottomInset() {
			return
		}

		let newBottomInset: CGFloat
		if isKeyboardVisible {
			view.layoutViewIfNeededOrSetNeedsLayout()
			buttonsView.layoutViewIfNeededOrSetNeedsLayout()

			let overlayHeight = max(buttonsView.frame.height, keyboardHeight)

			newBottomInset = overlayHeight - view.safeAreaInsets.bottom
		} else {
			if isButtonsViewVisible {
				view.layoutViewIfNeededOrSetNeedsLayout()
				buttonsView.layoutViewIfNeededOrSetNeedsLayout()

				newBottomInset = buttonsView.frame.height - view.safeAreaInsets.bottom
			} else {
				newBottomInset = 0
			}
		}

		adjust(
			contentScrollView: contentScrollViewToAdjustBottomInset(),
			bottomInset: newBottomInset,
			isButtonsViewVisible: isButtonsViewVisible
		)
	}
}

private extension BaseTableVCWithSafeAreadButtons {
	func setUpConstraints() {
		view.addSubviewForConstraintsUse(tableView)
		NSLayoutConstraint.activate(tableView.makeEdgeConstraintsEqualToSuperviewSafeArea(leading: 0, top: 0, trailing: 0, bottom: 0))
	}

	func setUpUI() {
		observeKeyboardWillChangeFrame { [weak self] notification in
			UIView.animate(
				duration: notification.animationDuration,
				options: notification.animationOptions
			) { [weak self] in
				guard let self else {
					return
				}

				setUpContentScrollViewBottomInset(isButtonsViewVisible: !buttonsView.isHidden)
			}
		}
	}
}
