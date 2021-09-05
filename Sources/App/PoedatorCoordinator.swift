//
//  PoedatorCoordinator.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import StoreKit
import UIKit

final class PoedatorCoordinator: BaseCoordinator {
	private let assembly: PoedatorCoordinatorAssembly
	private let calculateMealTimeScheduleAssembly: PoedatorCalculateMealTimeScheduleAssembly
	private let calendar: Calendar
	private let poedatorMealTimeScheduleStoreFacade: IPoedatorMealTimeScheduleStoreFacade
	private let savedMealTimeScheduleAssembly: PoedatorSavedMealTimeScheduleAssembly

	private weak var application: UIApplication?
	private weak var window: BaseWindow?

	private weak var calculateMealTimeSchedulePresenterInput: IPoedatorCalculateMealTimeSchedulePresenterInput?
	private weak var calculateMealTimeScheduleVC: BaseVC?
	private weak var savedMealTimeScheduleVC: BaseVC?

	weak var delegate: IPoedatorCoordinatorDelegate?

	override var flowName: String {
		String(localized: "Poedator")
	}

	init(
		application: UIApplication,
		appStore: AppStore.Type,
		assembly: PoedatorCoordinatorAssembly,
		calculateMealTimeScheduleAssembly: PoedatorCalculateMealTimeScheduleAssembly,
		calendar: Calendar,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		poedatorMealTimeScheduleStoreFacade: IPoedatorMealTimeScheduleStoreFacade,
		savedMealTimeScheduleAssembly: PoedatorSavedMealTimeScheduleAssembly,
		window: BaseWindow,
		windowScene: UIWindowScene
	) {
		self.application = application
		self.assembly = assembly
		self.calculateMealTimeScheduleAssembly = calculateMealTimeScheduleAssembly
		self.calendar = calendar
		self.poedatorMealTimeScheduleStoreFacade = poedatorMealTimeScheduleStoreFacade
		self.savedMealTimeScheduleAssembly = savedMealTimeScheduleAssembly
		self.window = window

		super.init(
			appStore: appStore,
			didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator,
			windowScene: windowScene
		)
	}

	override func startFlow(from transitionHandler: UIViewController) {
		super.startFlow(from: transitionHandler)

		let savedMealTimeScheduleVC = savedMealTimeScheduleAssembly.makeVC(coordinator: self)
		self.savedMealTimeScheduleVC = savedMealTimeScheduleVC

		if let svc {
			guard let (calculateMealTimeScheduleVC, calculateMealTimeSchedulePresenterInput) = makeCalculateMealTimeScheduleVC() else {
				assertionFailure("?")
				return
			}

			self.calculateMealTimeScheduleVC = calculateMealTimeScheduleVC
			self.calculateMealTimeSchedulePresenterInput = calculateMealTimeSchedulePresenterInput

			svc.viewControllers = [
				savedMealTimeScheduleVC,
				calculateMealTimeScheduleVC
			].map(BaseNavigationController.init(rootViewController:))
		} else if let nc {
			nc.pushViewController(savedMealTimeScheduleVC, animated: shouldAnimate)
		} else {
			assertionFailure("?")
		}
	}
}

extension PoedatorCoordinator {
	func showCalculateMealTimeSchedule(fromRestore: Bool) {
		if !fromRestore {
			prepareDidChangeScreenFeedbackGenerator()
		}

		guard let (calculateMealTimeScheduleVC, calculateMealTimeSchedulePresenterInput) = makeCalculateMealTimeScheduleVC() else {
			assertionFailure("?")
			return
		}

		self.calculateMealTimeScheduleVC = calculateMealTimeScheduleVC
		self.calculateMealTimeSchedulePresenterInput = calculateMealTimeSchedulePresenterInput

		if let svc {
			svc.showDetailViewController(
				BaseNavigationController(rootViewController: calculateMealTimeScheduleVC),
				sender: nil
			)
		} else if let nc {
			nc.pushViewController(calculateMealTimeScheduleVC, animated: shouldAnimate)
		} else {
			assertionFailure("?")
		}

		if !fromRestore {
			triggerDidChangeScreenFeedbackGenerator()
		}
	}

	func resetCalculateMealTimeSchedule() {
		calculateMealTimeSchedulePresenterInput?.reset()
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

	func goToSavedMealTimeScheduleIfNeeded() {
		prepareDidChangeScreenFeedbackGenerator()

		let navigationController: BaseNavigationController
		if let svc {
			if svc.viewControllers.count == 1 {
				guard let nc = svc.viewControllers.last as? BaseNavigationController else {
					assertionFailure("?")
					return
				}

				navigationController = nc
			} else {
				return
			}
		} else if let nc {
			navigationController = nc
		} else {
			assertionFailure("?")
			return
		}

		navigationController.popViewController(animated: shouldAnimate)

		triggerDidChangeScreenFeedbackGenerator()
	}

	func didUpdateMealTimeSchedule() {
		delegate?.didUpdateMealTimeSchedule()
	}
}

extension PoedatorCoordinator: IRestorable {
	func saveUserActivityForRestore(to userActivity: NSUserActivity) {
		if let svc {
			if svc.viewControllers.count == 1 {
				guard let topVC = svc.topVC else {
					assertionFailure("?")
					return
				}

				let vc: BaseVC
				if topVC is PopoverVC {
					guard let lastVC = svc.viewControllers.last as? BaseVC else {
						assertionFailure("?")
						return
					}
					vc = lastVC
				} else {
					vc = topVC
				}

				userActivity.restoredVCType = vc.vcType
			}
		} else if let nc {
			guard let topVC = nc.topVC else {
				assertionFailure("?")
				return
			}

			let vc: BaseVC
			if topVC is PopoverVC {
				guard let lastVC = nc.viewControllers.last as? BaseVC else {
					assertionFailure("?")
					return
				}
				vc = lastVC
			} else {
				vc = topVC
			}

			userActivity.restoredVCType = vc.vcType
		} else {
			assertionFailure("?")
		}

		savedMealTimeScheduleVC?.saveUserActivityForRestore(to: userActivity)
		calculateMealTimeScheduleVC?.saveUserActivityForRestore(to: userActivity)
	}

	func restore(from userActivity: NSUserActivity) {
		if let svc {
			if svc.viewControllers.count == 1 {
				guard let restoredVCType = userActivity.restoredVCType else {
					assertionFailure("?")
					return
				}

				switch restoredVCType {
				case .savedMealTimeSchedule:
					savedMealTimeScheduleVC?.restore(from: userActivity)

				case .calculateMealTimeSchedule:
					guard let calculateMealTimeScheduleVC else {
						assertionFailure("?")
						return
					}

					svc.showDetailViewController(calculateMealTimeScheduleVC, sender: nil)
					calculateMealTimeScheduleVC.restore(from: userActivity)
				}
			}
		} else if nc != nil {
			guard let restoredVCType = userActivity.restoredVCType else {
				assertionFailure("?")
				return
			}

			switch restoredVCType {
			case .savedMealTimeSchedule:
				savedMealTimeScheduleVC?.restore(from: userActivity)

			case .calculateMealTimeSchedule:
				if calculateMealTimeScheduleVC == nil {
					showCalculateMealTimeSchedule(fromRestore: true)
				}
				calculateMealTimeScheduleVC?.restore(from: userActivity)
			}
		} else {
			assertionFailure("?")
		}
	}
}

private extension PoedatorCoordinator {
	func makeCalculateMealTimeScheduleVC() -> (vc: BaseVC, presenterInput: IPoedatorCalculateMealTimeSchedulePresenterInput)? {
		guard let window else {
			assertionFailure("?")
			return nil
		}

		let poedatorMealTimeSchedule = poedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.iCloud, .sharedLocal])

		let poedatorMealTimeScheduleCount = UInt(poedatorMealTimeSchedule.count)

		return calculateMealTimeScheduleAssembly.makeVC(
			coordinator: self,
			currentNumberOfMealTimes: poedatorMealTimeScheduleCount > 0 ? poedatorMealTimeScheduleCount : nil,
			currentFirstMealTime: poedatorMealTimeSchedule.first,
			currentLastMealTime: poedatorMealTimeSchedule.last,
			shouldAutoDeleteMealSchedule: poedatorMealTimeScheduleStoreFacade.shouldAutoDeleteMealSchedule,
			window: window
		)
	}
}

private extension BaseVC {
	var vcType: PoedatorCoordinator.RestoredVCType? {
		if self is PoedatorSavedMealTimeScheduleVC {
			return .savedMealTimeSchedule
		}

		if self is PoedatorCalculateMealTimeScheduleVC {
			return .calculateMealTimeSchedule
		}

		assertionFailure("?")
		return nil
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
