//
//  PoedatorCoordinator.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class PoedatorCoordinator: BaseCoordinator {
	private let assembly: PoedatorCoordinatorAssembly
	private let calendar: Calendar
	private let userDefaultsFacade: UserDefaultsFacade

	private weak var application: UIApplication?
	private weak var delegate: PoedatorCoordinatorDelegate?

	init(
		application: UIApplication,
		assembly: PoedatorCoordinatorAssembly,
		calendar: Calendar,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		userDefaultsFacade: UserDefaultsFacade
	) {
		self.application = application
		self.assembly = assembly
		self.calendar = calendar
		self.userDefaultsFacade = userDefaultsFacade

		super.init(didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator)
	}
}

extension PoedatorCoordinator {
	func startFlow(from transitionHandler: UIViewController) {
		self.transitionHandler = transitionHandler

		let yourMealTimeListVC = assembly.yourMealTimeList(coordinator: self)

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.viewControllers = [yourMealTimeListVC]
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			splitViewController.viewControllers = [yourMealTimeListVC.wrappedInPlainNavigation()]
		}
	}

	func showCalculateMealTimeList(delegate: PoedatorCoordinatorDelegate) {
		guard let transitionHandler else {
			assertionFailure("?")
			return
		}

		self.delegate = delegate
		didChangeScreenFeedbackGenerator.prepare()

		let currentDate = Date()

		guard var inputedFirstMealTime = calendar.date(bySetting: .second, value: 0, of: currentDate) else {
			assertionFailure("?")
			return
		}

		guard let inputedLastMealTime = calendar.date(
			bySettingHour: 20,
			minute: 30,
			second: 0,
			of: currentDate
		) else {
			assertionFailure("?")
			return
		}

		if inputedFirstMealTime >= inputedLastMealTime {
			guard let defaultFirstMealTime = calendar.date(
				bySettingHour: 9,
				minute: 30,
				second: 0,
				of: currentDate
			) else {
				assertionFailure("?")
				return
			}

			inputedFirstMealTime = defaultFirstMealTime
		}

		let calculateMealTimeListVC = assembly.calculateMealTimeList(
			coordinator: self,
			inputedNumberOfMealTimes: userDefaultsFacade.inputedNumberOfMealTimes,
			inputedFirstMealTime: userDefaultsFacade.inputedFirstMealTime,
			inputedLastMealTime: userDefaultsFacade.inputedLastMealTime
		)

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.pushViewController(calculateMealTimeListVC, animated: true)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			let noCalculateMealTimeListVC = !(splitViewController.detailViewController is PoedatorCalculateMealTimeListVC)

			if splitViewController.hasNoDetailViewController || noCalculateMealTimeListVC {
				splitViewController.showDetailViewController(calculateMealTimeListVC.wrappedInPlainNavigation())
			}
		}

		didChangeScreenFeedbackGenerator.impactOccurred()
	}

	func goToAppNotificationSettings() {
		guard let application,
			  let settingsUrl = URL(string: UIApplication.openNotificationSettingsURLString),
			  application.canOpenURL(settingsUrl)
		else {
			assertionFailure("?")
			return
		}

		application.open(settingsUrl)
	}

	func hideCalculateMealTimeList() {
		guard let transitionHandler else {
			assertionFailure("?")
			return
		}

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.popViewController(animated: true)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			splitViewController.hideDetailViewController()
		}

		delegate?.didHideCalculateMealTimeListScreen()
	}
}
