//
//  BaseVC.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

class BaseVC: UIViewController {
	private let output: BaseViewOutput?
	var tasks: [AnyTask]

	private(set) final var isViewVisible: Bool

	private lazy var gradientLayer = CAGradientLayer()

	init(output: BaseViewOutput? = nil) {
		self.output = output
		isViewVisible = false
		tasks = []

		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	convenience init() {
		fatalError("Use init(output:) initializer")
	}

	@available(*, unavailable)
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		fatalError("init(nibName:bundle:) has not been implemented")
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemGroupedBackground

		gradientLayer.colors = [view.backgroundColor!.cgColor, Color.brand.uiColor.cgColor]
		gradientLayer.locations = [0.5, 1]
		view.layer.insertSublayer(gradientLayer, at: 0)

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

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		gradientLayer.frame = view.bounds
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		isViewVisible = true
		output?.baseViewDidAppear()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		isViewVisible = false
	}

	deinit {
		tasks = []
	}
}

extension BaseVC {
	var preferredAnimationDuration: TimeInterval {
		isViewVisible ? .defaultAnimationDuration : 0
	}

	@MainActor
	func observeKeyboardWillShow(
		onReceiveNotification: @escaping (Result<KeyboardNotification, Error>) -> Void
	) {
		let task = Task { [weak self] in
			await self?.notificationCenter.willShowKeyboardNotifications(onReceiveNotification: onReceiveNotification)
		}

		tasks.append(task)
	}

	@MainActor
	func observeKeyboardDidShow(
		onReceiveNotification: @escaping (Result<KeyboardNotification, Error>) -> Void
	) {
		let task = Task { [weak self] in
			await self?.notificationCenter.didShowKeyboardNotifications(onReceiveNotification: onReceiveNotification)
		}

		tasks.append(task)
	}

	@MainActor
	func observeKeyboardWillHide(
		onReceiveNotification: @escaping (Result<KeyboardNotification, Error>) -> Void
	) {
		let task = Task { [weak self] in
			await self?.notificationCenter.willHideKeyboardNotifications(onReceiveNotification: onReceiveNotification)
		}

		tasks.append(task)
	}

	@MainActor
	func observeKeyboardDidHide(
		onReceiveNotification: @escaping (Result<KeyboardNotification, Error>) -> Void
	) {
		let task = Task { [weak self] in
			await self?.notificationCenter.didHideKeyboardNotifications(onReceiveNotification: onReceiveNotification)
		}

		tasks.append(task)
	}

	@MainActor
	func observeKeyboardWillChangeFrame(
		onReceiveNotification: @escaping (Result<KeyboardNotification, Error>) -> Void
	) {
		let task = Task { [weak self] in
			await self?.notificationCenter.willChangeKeyboardFrameNotifications(onReceiveNotification: onReceiveNotification)
		}

		tasks.append(task)
	}

	@MainActor
	func observeKeyboardDidChangeFrame(
		onReceiveNotification: @escaping (Result<KeyboardNotification, Error>) -> Void
	) {
		let task = Task { [weak self] in
			await self?.notificationCenter.didChangeKeyboardFrameNotifications(onReceiveNotification: onReceiveNotification)
		}

		tasks.append(task)
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
}
