//
//  BaseCoordinator.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import StoreKit
import UIKit

@MainActor
class BaseCoordinator {
	private let appStore: AppStore.Type
	private let didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator

	var tasks: [AnyTask]

	private(set) weak var popoverVC: PopoverVC?

	var flowName: String {
		""
	}

	private(set) weak var transitionHandler: UIViewController?
	private(set) weak var windowScene: UIWindowScene?

	init(
		appStore: AppStore.Type,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		windowScene: UIWindowScene
	) {
		self.appStore = appStore
		self.didChangeScreenFeedbackGenerator = didChangeScreenFeedbackGenerator
		self.windowScene = windowScene

		tasks = []
	}

	func startFlow(from transitionHandler: UIViewController) {
		self.transitionHandler = transitionHandler
		prepareDidChangeScreenFeedbackGenerator()
	}

	deinit {
		for task in tasks {
			task.cancel()
		}
	}
}

extension BaseCoordinator {
	var shouldAnimate: Bool {
		if UIAccessibility.isReduceMotionEnabled {
			return UIAccessibility.prefersCrossFadeTransitions
		}

		return true
	}

	var svc: BaseSplitViewController? {
		transitionHandler as? BaseSplitViewController
	}

	var nc: BaseNavigationController? {
		transitionHandler as? BaseNavigationController
	}
}

extension BaseCoordinator {
	var isShowingPopover: Bool {
		popoverVC?.isViewVisible == true
	}

	func prepareDidChangeScreenFeedbackGenerator() {
		didChangeScreenFeedbackGenerator.prepare()
	}

	func triggerDidChangeScreenFeedbackGenerator() {
		didChangeScreenFeedbackGenerator.impactOccurred()
	}

	func passToPopover(
		presses: Set<UIPress>,
		event: UIPressesEvent?,
		superImplementation: HandlePressesClosure
	) {
		let topVC: BaseVC?
		if let svc {
			topVC = svc.topVC
		} else if let nc {
			topVC = nc.topVC
		} else {
			assertionFailure("?")
			return
		}

		guard let topVC else {
			assertionFailure("?")
			return
		}

		assert(topVC is PopoverVC)

		topVC.handle(presses: presses, event: event, superImplementation: superImplementation)
	}

	func showAlert(
		title: String?,
		message: String?,
		actions: [UIAlertAction],
		preferredAction: UIAlertAction
	) {
		guard let transitionHandler else {
			assertionFailure("?")
			return
		}

		let alertController = BaseAlertController.alert(
			title: title,
			message: message,
			actions: actions,
			preferredAction: preferredAction
		)

		transitionHandler.present(alertController, animated: shouldAnimate)
	}

	func showErrorAlert(
		message: String?,
		yesActionStyle: UIAlertAction.Style,
		noActionStyle: UIAlertAction.Style,
		didTapYesAction: (() -> Void)?,
		didTapNoAction: (() -> Void)?
	) {
		showAlert(
			title: String(localized: "Error"),
			message: message,
			yesActionStyle: yesActionStyle,
			noActionStyle: noActionStyle,
			didTapYesAction: didTapYesAction,
			didTapNoAction: didTapNoAction
		)
	}

	func showAlert(
		title: String?,
		message: String?,
		yesActionStyle: UIAlertAction.Style,
		noActionStyle: UIAlertAction.Style,
		didTapYesAction: (() -> Void)?,
		didTapNoAction: (() -> Void)?
	) {
		prepareDidChangeScreenFeedbackGenerator()

		let yesAction = UIAlertAction(
			title: String(localized: "Yes"),
			style: yesActionStyle
		) { _ in
			didTapYesAction?()
		}

		let noAction = UIAlertAction(
			title: String(localized: "No"),
			style: noActionStyle
		) { _ in
			didTapNoAction?()
		}

		showAlert(
			title: title,
			message: message,
			actions: [yesAction, noAction],
			preferredAction: yesAction
		)

		triggerDidChangeScreenFeedbackGenerator()
	}

	func showAlert(
		title: String?,
		message: String?,
		okActionStyle: UIAlertAction.Style = .default,
		didTapOkAction: (() -> Void)? = nil
	) {
		let okAction = UIAlertAction(
			title: String(localized: "OK"),
			style: okActionStyle
		) { _ in
			didTapOkAction?()
		}

		showAlert(title: title, message: message, actions: [okAction], preferredAction: okAction)
	}

	func showPopover(text: String, on view: UIView, permittedArrowDirections: [PopoverArrowDirection]) {
		guard let transitionHandler else {
			assertionFailure("?")
			return
		}

		didChangeScreenFeedbackGenerator.prepare()

		let popoverVC = PopoverVC(
			sourceView: view,
			text: text,
			permittedArrowDirections: permittedArrowDirections
		)
		self.popoverVC = popoverVC

		transitionHandler.present(popoverVC, animated: shouldAnimate)

		didChangeScreenFeedbackGenerator.impactOccurred()
	}

	func hidePopoverIfNeeded() {
		popoverVC?.dismiss(animated: shouldAnimate)
	}

	func requestReview() {
		guard let windowScene else {
			assertionFailure("?")
			return
		}

		appStore.requestReview(in: windowScene)
	}
}
