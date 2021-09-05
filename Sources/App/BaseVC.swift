//
//  BaseVC.swift
//  App
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

@MainActor
class BaseVC: UIViewController {
	private let output: IBaseViewOutput?
	private(set) var keyboardHeight: CGFloat = 0

	private(set) var isViewVisible: Bool
	var tasks: [AnyTask]

	var shouldAnimate: Bool {
		if UIAccessibility.isReduceMotionEnabled {
			return UIAccessibility.prefersCrossFadeTransitions
		}

		return isViewVisible
	}

	init(output: IBaseViewOutput? = nil) {
		self.output = output
		tasks = []
		isViewVisible = false

		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	convenience init() {
		fatalError("Use init(output:) initializer")
	}

	// swiftlint:disable unused_parameter
	@available(*, unavailable)
	override init(nibName: String?, bundle: Bundle?) {
		fatalError("init(nibName:bundle:) has not been implemented")
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// swiftlint:enable unused_parameter

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemGroupedBackground
		view.tintColor = ColorStyle.brand.color
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		isViewVisible = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if isMovingFromParent {
			output?.willMoveFromParentVC()
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		isViewVisible = false
		if isMovingFromParent {
			output?.didMoveFromParentVC()
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		output?.didReceiveMemoryWarning()
	}

	override func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
		super.present(viewControllerToPresent, animated: animated && shouldAnimate, completion: completion)
	}

	override final func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		handle(touches: touches, event: event, superImplementation: super.touchesBegan(_:with:))
	}

	override final func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		handle(touches: touches, event: event, superImplementation: super.touchesMoved(_:with:))
	}

	override final func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		handle(touches: touches, event: event, superImplementation: super.touchesEnded(_:with:))
	}

	override final func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		handle(touches: touches, event: event, superImplementation: super.touchesCancelled(_:with:))
	}

	func handle(
		touches: Set<UITouch>,
		event: UIEvent?,
		superImplementation: HandleTouchesClosure
	) {
		superImplementation(touches, event)
	}

	override final func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesBegan(_:with:))
	}

	override final func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesChanged(_:with:))
	}

	override final func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesEnded(_:with:))
	}

	override final func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		handle(presses: presses, event: event, superImplementation: super.pressesCancelled(_:with:))
	}

	func handle(
		presses: Set<UIPress>,
		event: UIPressesEvent?,
		superImplementation: HandlePressesClosure
	) {
		superImplementation(presses, event)
	}

	// swiftlint:disable:next unused_parameter
	func traitPreferredContentSizeCategoryDidChange(_ previousTraitCollection: UITraitCollection) {
		// implement
	}

	deinit {
		for task in tasks {
			task.cancel()
		}
	}
}

extension BaseVC {
	var defaultAnimationDuration: TimeInterval {
		if !shouldAnimate {
			return 0
		}

		return .defaultAnimationDuration
	}

	var isSplitViewMode: Bool {
		splitViewController?.viewControllers.count == 2
	}

	var isKeyboardVisible: Bool {
		keyboardHeight > 0
	}

	func observeKeyboardWillChangeFrame(
		onReceiveNotification: @escaping (KeyboardNotification) -> Void
	) {
		assert(!ProcessInfo.processInfo.isiOSAppOnMac)

		observeKeyboardWillChangeFrame { [weak self] result in
			self?.handle(
				keyboardNotificationResult: result,
				onReceiveNotification: onReceiveNotification
			)
		}
	}

	func observeSceneWillEnterForeground(
		onReceiveNotification: @escaping () -> Void
	) {
		observeSceneWillEnterForeground { result in
			switch result {
			case .success: onReceiveNotification()
			case .failure: assertionFailure("?")
			}
		}
	}

	@discardableResult
	func registerForTraitPreferredContentSizeCategoryChanges() -> any UITraitChangeRegistration {
		registerForTraitChanges([UITraitPreferredContentSizeCategory.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
			self.traitPreferredContentSizeCategoryDidChange(previousTraitCollection)
		}
	}

	func setUpNCBackButton() {
		navigationItem.backAction = UIAction { [weak output] _ in
			output?.didTapNCBackButton()
		}
	}
}

extension BaseVC: IRestorable {
	func saveUserActivityForRestore(to userActivity: NSUserActivity) {
		guard let output = output as? IRestorable else {
			return
		}

		output.saveUserActivityForRestore(to: userActivity)
	}

	func restore(from userActivity: NSUserActivity) {
		guard let output = output as? IRestorable else {
			return
		}

		output.restore(from: userActivity)
	}
}

private extension BaseVC {
	func handle(
		keyboardNotificationResult: Result<KeyboardNotification, Error>,
		onReceiveNotification: @escaping (KeyboardNotification) -> Void
	) {
		guard let keyboardNotification = keyboardNotificationResult.value else {
			assertionFailure("?")
			return
		}

		if !keyboardNotification.isLocal {
			return
		}

		let keyboardFrameBegin = keyboardNotification.frameBegin(inCoordinateSpaceOf: view)
		let keyboardFrameEnd = keyboardNotification.frameEnd(inCoordinateSpaceOf: view)

		if keyboardFrameBegin == keyboardFrameEnd {
			// если ничего не изменится, то нет смысла что-то делать дальше
			return
		}

		if keyboardFrameEnd.origin.y == view.frame.height {
			keyboardHeight = 0
		} else {
			if keyboardHeight == keyboardFrameEnd.height {
				// если ничего не изменится, то нет смысла что-то делать дальше
				return
			}

			keyboardHeight = keyboardFrameEnd.height
		}

		onReceiveNotification(keyboardNotification)
	}

	func observeKeyboardWillChangeFrame(
		onReceiveNotification: @escaping OnReceiveKeyboardNotification
	) {
		let task = Task {
			await NotificationCenter.default.willChangeKeyboardFrameNotifications(
				onReceiveNotification: onReceiveNotification
			)
		}

		tasks.append(task)
	}

	func observeSceneWillEnterForeground(
		onReceiveNotification: @escaping OnReceiveSceneNotification
	) {
		let task = Task {
			await NotificationCenter.default.willEnterForegroundNotifications(
				onReceiveNotification: onReceiveNotification
			)
		}

		tasks.append(task)
	}
}
