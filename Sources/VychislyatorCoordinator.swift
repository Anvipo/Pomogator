//
//  VychislyatorCoordinator.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class VychislyatorCoordinator: BaseCoordinator {
	private let assembly: VychislyatorCoordinatorAssembly
	private let userDefaultsFacade: VychislyatorDailyCalorieIntakeUserDefaultsFacade

	private weak var formulasListVC: BaseVC?

	init(
		assembly: VychislyatorCoordinatorAssembly,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		userDefaultsFacade: VychislyatorDailyCalorieIntakeUserDefaultsFacade
	) {
		self.assembly = assembly
		self.userDefaultsFacade = userDefaultsFacade

		super.init(didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator)
	}

	override func startFlow(from transitionHandler: UIViewController) {
		super.startFlow(from: transitionHandler)

		let formulasListVC = assembly.formulasList(coordinator: self)
		self.formulasListVC = formulasListVC

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.viewControllers = [formulasListVC]
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			splitViewController.viewControllers = [formulasListVC.wrappedInPlainNavigation()]
		}
	}
}

extension VychislyatorCoordinator {
	func showDailyCalorieIntakeFormulasScreen(animated: Bool) {
		guard let transitionHandler else {
			assertionFailure("?")
			return
		}

		didChangeScreenFeedbackGenerator.prepare()

		let personSexes = PersonSex.allCases
		let physicalActivities = PhysicalActivity.allCases

		let selectedPersonSex: PersonSex
		if let selectedPersonSexIndex = userDefaultsFacade.selectedPersonSexIndex {
			selectedPersonSex = personSexes[Int(selectedPersonSexIndex)]
		} else {
			selectedPersonSex = .male
		}

		let selectedPhysicalActivity: PhysicalActivity
		if let selectedPhysicalActivityIndex = userDefaultsFacade.selectedPhysicalActivityIndex {
			selectedPhysicalActivity = physicalActivities[Int(selectedPhysicalActivityIndex)]
		} else {
			selectedPhysicalActivity = .low
		}

		let dailyCalorieIntakeFormulasListVC = assembly.dailyCalorieIntakeFormulasList(
			coordinator: self,
			personSexes: personSexes,
			selectedPersonSex: selectedPersonSex,
			inputedAgeInYears: userDefaultsFacade.ageInYears,
			inputedHeightInCm: userDefaultsFacade.heightInCm,
			inputedMassInKg: userDefaultsFacade.massInKg,
			physicalActivities: physicalActivities,
			selectedPhysicalActivity: selectedPhysicalActivity
		)

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.pushViewController(dailyCalorieIntakeFormulasListVC, animated: animated)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			let noDailyCalorieIntakeFormulasListVC = !(splitViewController.detailVC is VychislyatorDailyCalorieIntakeFormulasListVC)

			if splitViewController.detailVC == nil || noDailyCalorieIntakeFormulasListVC {
				splitViewController.showDetailVC(dailyCalorieIntakeFormulasListVC.wrappedInPlainNavigation())
			}
		}

		didChangeScreenFeedbackGenerator.impactOccurred()
	}

	func showBodyMassIndexScreen(animated: Bool) {
		guard let transitionHandler else {
			assertionFailure("?")
			return
		}

		didChangeScreenFeedbackGenerator.prepare()

		let bodyMassIndexVC = assembly.bodyMassIndex(
			coordinator: self,
			currentMassInKg: userDefaultsFacade.massInKg,
			currentHeightInCm: userDefaultsFacade.heightInCm
		)

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.pushViewController(bodyMassIndexVC, animated: animated)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			let noBodyMassIndexVC = !(splitViewController.detailVC is VychislyatorBodyMassIndexVC)

			if splitViewController.detailVC == nil || noBodyMassIndexVC {
				splitViewController.showDetailVC(bodyMassIndexVC.wrappedInPlainNavigation())
			}
		}

		didChangeScreenFeedbackGenerator.impactOccurred()
	}

	func showPopover(text: String, on view: UIView) {
		guard let formulasListVC else {
			assertionFailure("?")
			return
		}

		didChangeScreenFeedbackGenerator.prepare()

		let popoverVC = VychislyatorFormulasListPopoverVC(
			sourceView: view,
			text: text
		)

		formulasListVC.present(popoverVC, animated: true)

		didChangeScreenFeedbackGenerator.impactOccurred()
	}

	func goToRootScreen(animated: Bool) {
		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.popToRootViewController(animated: animated)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			splitViewController.hideDetailVC()
		}
	}
}

extension VychislyatorCoordinator: IRestorable {
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

		if currentActiveVC?.vcType != restoredVCType {
			switch restoredVCType {
			case .formulasList:
				goToRootScreen(animated: true)

			case .dailyCalorieIntake:
				showDailyCalorieIntakeFormulasScreen(animated: true)

			case .bodyMassIndex:
				showBodyMassIndexScreen(animated: true)
			}
		}

		currentActiveVC?.restore(from: userActivity)
	}
}

private extension BaseVC {
	var vcType: VychislyatorCoordinator.RestoredVCType? {
		if self is VychislyatorFormulasListVC {
			return .formulasList
		} else if self is VychislyatorDailyCalorieIntakeFormulasListVC {
			return .dailyCalorieIntake
		} else if self is VychislyatorBodyMassIndexVC {
			return .bodyMassIndex
		} else {
			assertionFailure("?")
			return nil
		}
	}
}

private extension String {
	static var restoredVCTypeKey: Self {
		"vychislyator.restoredVCType"
	}
}

private extension NSUserActivity {
	var restoredVCType: VychislyatorCoordinator.RestoredVCType? {
		get {
			guard let userInfo,
				  let restoredVCTypeRawValue = userInfo[String.restoredVCTypeKey] as? VychislyatorCoordinator.RestoredVCType.RawValue,
				  let restoredVCType = VychislyatorCoordinator.RestoredVCType(rawValue: restoredVCTypeRawValue)
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
