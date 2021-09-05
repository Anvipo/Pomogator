//
//  BaseVC.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

class BaseVC: UIViewController {
	private let output: BaseViewOutput?
	final var tasks: [AnyTask]

	private(set) final var keyboardHeight: CGFloat = 0

	init(output: BaseViewOutput? = nil) {
		self.output = output
		tasks = []

		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	convenience init() {
		fatalError("Use init(output:) initializer")
	}

	@available(*, unavailable)
	override init(nibName: String?, bundle: Bundle?) {
		fatalError("init(nibName:bundle:) has not been implemented")
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemGroupedBackground

		guard let navigationController else {
			return
		}

		let shouldShowBackButton = navigationController.viewControllers.count > 1
		if !shouldShowBackButton {
			return
		}

		navigationItem.backAction = UIAction { [weak self] _ in
			guard let self else {
				return
			}

			guard let navigationController = self.navigationController else {
				assertionFailure("?")
				return
			}

			navigationController.popViewController(animated: true)
			self.output?.didTapBackButton()
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		output?.baseViewDidAppear()
	}
}

extension BaseVC {
	var isViewVisible: Bool {
		view.isAddedToWindow
	}

	func animateIfNeeded(
		animationDuration: TimeInterval = .defaultAnimationDuration,
		animations: @escaping () -> Void
	) {
		if view.isAddedToWindow {
			UIView.animate(withDuration: animationDuration, animations: animations)
		} else {
			animations()
		}
	}

	func observeKeyboardWillChangeFrame(
		layoutSubviewsAfterKeyboardChange: @escaping () -> Void
	) {
		observeKeyboardWillChangeFrame { [weak self] result in
			self?.handle(
				keyboardNotificationResult: result,
				layoutSubviewsAfterKeyboardChange: layoutSubviewsAfterKeyboardChange
			)
		}
	}

	func addTapGestureForHidingKeyboard() {
		let tapGestureRecognizerForHidingKeyboard = UITapGestureRecognizer(
			target: self,
			action: #selector(didTapView)
		)
		tapGestureRecognizerForHidingKeyboard.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGestureRecognizerForHidingKeyboard)
	}
}

private extension BaseVC {
	var notificationCenter: NotificationCenter {
		.default
	}

	@objc
	func didTapView() {
		view.endEditing(true)
	}

	func handle(
		keyboardNotificationResult: Result<KeyboardNotification, Error>,
		layoutSubviewsAfterKeyboardChange: @escaping () -> Void
	) {
		guard let keyboardNotification = keyboardNotificationResult.value else {
			assertionFailure("?")
			return
		}

		if !keyboardNotification.isLocal {
			assertionFailure("?")
			return
		}

		if keyboardNotification.frameBegin == keyboardNotification.frameEnd {
			// если ничего не изменится, то нет смысла что-то делать дальше
			return
		}

		if keyboardNotification.frameEnd.origin.y == view.frame.height {
			keyboardHeight = 0
		} else {
			if keyboardHeight == keyboardNotification.frameEnd.height {
				// если ничего не изменится, то нет смысла что-то делать дальше
				return
			}

			keyboardHeight = keyboardNotification.frameEnd.height
		}

		if isViewVisible {
			view.layoutIfNeeded()

			UIViewPropertyAnimator(keyboardNotification: keyboardNotification) { [weak self] in
				layoutSubviewsAfterKeyboardChange()
				self?.view.layoutIfNeeded()
			}.startAnimation()
		} else {
			view.setNeedsLayout()
			layoutSubviewsAfterKeyboardChange()
			view.setNeedsLayout()
		}
	}

	func observeKeyboardWillChangeFrame(
		onReceiveNotification: @escaping OnReceiveKeyboardNotification
	) {
		let task = Task { [weak self] in
			await self?.notificationCenter.willChangeKeyboardFrameNotifications(onReceiveNotification: onReceiveNotification)
		}

		tasks.append(task)
	}
}
