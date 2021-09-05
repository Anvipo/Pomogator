//
//  PoedatorCoordinator.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class PoedatorCoordinator: BaseCoordinator {
	private let assembly: PoedatorCoordinatorAssembly
	private let userDefaultsFacade: PoedatorUserDefaultsFacade

	private weak var application: UIApplication?
	private weak var savedMealTimeScheduleVC: BaseVC?

	weak var delegate: PoedatorCoordinatorDelegate?

	init(
		application: UIApplication,
		assembly: PoedatorCoordinatorAssembly,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		userDefaultsFacade: PoedatorUserDefaultsFacade
	) {
		self.application = application
		self.assembly = assembly
		self.userDefaultsFacade = userDefaultsFacade

		super.init(didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator)
	}

	override func startFlow(from transitionHandler: UIViewController) {
		super.startFlow(from: transitionHandler)

		let savedMealTimeScheduleVC = assembly.savedMealTimeSchedule(coordinator: self)

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.viewControllers = [savedMealTimeScheduleVC]
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			splitViewController.viewControllers = [savedMealTimeScheduleVC.wrappedInPlainNavigation()]
		}
	}
}

extension PoedatorCoordinator {
	func showCalculateMealTimeSchedule() {
		guard let transitionHandler else {
			assertionFailure("?")
			return
		}

		didChangeScreenFeedbackGenerator.prepare()

		let calculateMealTimeScheduleVC = assembly.calculateMealTimeSchedule(
			coordinator: self,
			currentNumberOfMealTimes: userDefaultsFacade.mealTimeSchedule.isEmpty ? nil : UInt(userDefaultsFacade.mealTimeSchedule.count),
			currentFirstMealTime: userDefaultsFacade.mealTimeSchedule.first,
			currentLastMealTime: userDefaultsFacade.mealTimeSchedule.last
		)

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.pushViewController(calculateMealTimeScheduleVC, animated: true)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			let noCalculateMealTimeScheduleVC = !(splitViewController.detailVC is PoedatorCalculateMealTimeScheduleVC)

			if splitViewController.detailVC == nil || noCalculateMealTimeScheduleVC {
				splitViewController.showDetailVC(calculateMealTimeScheduleVC.wrappedInPlainNavigation())
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

	func hideCalculateMealTimeSchedule() {
		guard let transitionHandler else {
			assertionFailure("?")
			return
		}

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.popViewController(animated: true)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			splitViewController.hideDetailVC()
		}

		delegate?.didHideCalculateMealTimeScheduleScreen()
	}
}

extension PoedatorCoordinator: IRestorable {
	func saveUserActivityForRestore(to userActivity: NSUserActivity) {
		guard let currentActiveVC else {
			assertionFailure("?")
			return
		}

		userActivity.restoredVCType = currentActiveVC.vcType
		currentActiveVC.saveUserActivityForRestore(to: userActivity)
	}

	func restore(from userActivity: NSUserActivity) {
		guard let restoredVCType = userActivity.restoredVCType else {
			assertionFailure("?")
			return
		}

		if transitionHandler is UINavigationController {
			if currentActiveVC?.vcType != restoredVCType {
				switch restoredVCType {
				case .savedMealTimeSchedule:
					hideCalculateMealTimeSchedule()

				case .calculateMealTimeSchedule:
					showCalculateMealTimeSchedule()
				}
			}
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			switch restoredVCType {
			case .savedMealTimeSchedule:
				if splitViewController.detailVC is PoedatorCalculateMealTimeScheduleVC {
					hideCalculateMealTimeSchedule()
					currentActiveVC?.restore(from: userActivity)
				} else {
					assertionFailure("?")
				}

			case .calculateMealTimeSchedule:
				if splitViewController.detailVC == nil {
					// костыль, чтобы restore заработал
					Task { [weak self] in
						guard let self else {
							return
						}

						self.showCalculateMealTimeSchedule()
						self.currentActiveVC?.restore(from: userActivity)
					}
				} else {
					assertionFailure("?")
				}
			}
		} else {
			assertionFailure("?")
		}
	}
}

private extension BaseVC {
	var vcType: PoedatorCoordinator.RestoredVCType? {
		if self is PoedatorSavedMealTimeScheduleVC {
			return .savedMealTimeSchedule
		} else if self is PoedatorCalculateMealTimeScheduleVC {
			return .calculateMealTimeSchedule
		} else {
			assertionFailure("?")
			return nil
		}
	}
}

private extension String {
	static var restoredVCTypeKey: Self {
		"poedator.restoredVCType"
	}
}

private extension NSUserActivity {
	var restoredVCType: PoedatorCoordinator.RestoredVCType? {
		get {
			guard let userInfo,
				  let restoredVCTypeRawValue = userInfo[String.restoredVCTypeKey] as? PoedatorCoordinator.RestoredVCType.RawValue,
				  let restoredVCType = PoedatorCoordinator.RestoredVCType(rawValue: restoredVCTypeRawValue)
			else {
				return nil
			}

			return restoredVCType
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredVCTypeKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredVCTypeKey: newValue.rawValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}
}
