//
//  BaseCoordinator.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

class BaseCoordinator {
	let didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator

	weak var transitionHandler: UIViewController?

	init(didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator) {
		self.didChangeScreenFeedbackGenerator = didChangeScreenFeedbackGenerator
	}
}

extension BaseCoordinator: BaseCoordinatorProtocol {
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

		let alertController = UIAlertController.alert(
			title: title,
			message: message,
			actions: actions,
			preferredAction: preferredAction
		)
		alertController.view.tintColor = Color.brand.uiColor

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.viewControllers.last?.present(alertController, animated: true)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			splitViewController.viewControllers.last?.present(alertController, animated: true)
		} else {
			assertionFailure("?")
		}
	}

	// swiftlint:disable:next function_parameter_count
	func showAlert(
		title: String?,
		message: String?,
		yesActionStyle: UIAlertAction.Style,
		noActionStyle: UIAlertAction.Style,
		didTapYesAction: (() -> Void)?,
		didTapNoAction: (() -> Void)?
	) {
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

		showAlert(title: title, message: message, actions: [yesAction, noAction], preferredAction: yesAction)
	}

	func showAlert(
		title: String?,
		message: String?,
		didTapOkAction: (() -> Void)?
	) {
		let okAction = UIAlertAction(title: String(localized: "OK"), style: .default) { _ in
			didTapOkAction?()
		}
		showAlert(title: title, message: message, actions: [okAction], preferredAction: okAction)
	}
}
