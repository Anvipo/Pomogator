//
//  VychislyatorCoordinator.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class VychislyatorCoordinator: BaseCoordinator {
	private let assembly: VychislyatorCoordinatorAssembly
	private let userDefaultsFacade: UserDefaultsFacade

	private weak var formulasListVC: UIViewController?

	init(
		assembly: VychislyatorCoordinatorAssembly,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		userDefaultsFacade: UserDefaultsFacade
	) {
		self.assembly = assembly
		self.userDefaultsFacade = userDefaultsFacade

		super.init(didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator)
	}
}

extension VychislyatorCoordinator {
	func startFlow(from transitionHandler: UIViewController) {
		self.transitionHandler = transitionHandler

		let formulasListVC = assembly.formulasList(coordinator: self)
		self.formulasListVC = formulasListVC

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.viewControllers = [formulasListVC]
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			splitViewController.viewControllers = [formulasListVC.wrappedInPlainNavigation()]
		}
	}

	func showDailyCalorieIntakeFormulasScreen(animated: Bool) {
		guard let transitionHandler else {
			assertionFailure("?")
			return
		}

		didChangeScreenFeedbackGenerator.prepare()

		let personSexes = PersonSex.allCases
		let physicalActivities = PhysicalActivity.allCases

		let selectedPersonSex: PersonSex
		if let inputedSelectedPersonSexIndex = userDefaultsFacade.inputedDailyCalorieIntakeSelectedPersonSexIndex {
			selectedPersonSex = personSexes[Int(inputedSelectedPersonSexIndex)]
		} else {
			selectedPersonSex = .male
		}

		let selectedPhysicalActivity: PhysicalActivity
		if let inputedSelectedPhysicalActivityIndex = userDefaultsFacade.inputedDailyCalorieIntakeSelectedPhysicalActivityIndex {
			selectedPhysicalActivity = physicalActivities[Int(inputedSelectedPhysicalActivityIndex)]
		} else {
			selectedPhysicalActivity = .low
		}

		let dailyCalorieIntakeFormulasListVC = assembly.dailyCalorieIntakeFormulasList(
			coordinator: self,
			personSexes: personSexes,
			selectedPersonSex: selectedPersonSex,
			inputedAgeInYears: userDefaultsFacade.inputedDailyCalorieIntakeAgeInYears,
			inputedHeightInCm: userDefaultsFacade.inputedDailyCalorieIntakeHeightInCm,
			inputedMassInKg: userDefaultsFacade.inputedDailyCalorieIntakeMassInKg,
			physicalActivities: physicalActivities,
			selectedPhysicalActivity: selectedPhysicalActivity
		)

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.pushViewController(dailyCalorieIntakeFormulasListVC, animated: animated)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			let noDailyCalorieIntakeFormulasListVC = !(splitViewController.detailViewController is VychislyatorDailyCalorieIntakeFormulasListVC)

			if splitViewController.hasNoDetailViewController || noDailyCalorieIntakeFormulasListVC {
				splitViewController.showDetailViewController(dailyCalorieIntakeFormulasListVC.wrappedInPlainNavigation())
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
			inputedMassInKg: userDefaultsFacade.inputedBodyMassIndexMassInKg,
			inputedHeightInCm: userDefaultsFacade.inputedBodyMassIndexHeightInCm
		)

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.pushViewController(bodyMassIndexVC, animated: animated)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			let noBodyMassIndexVC = !(splitViewController.detailViewController is VychislyatorBodyMassIndexVC)

			if splitViewController.hasNoDetailViewController || noBodyMassIndexVC {
				splitViewController.showDetailViewController(bodyMassIndexVC.wrappedInPlainNavigation())
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

		let vc = VychislyatorFormulasListPopoverVC(
			sourceView: view,
			text: text
		)

		formulasListVC.present(vc, animated: true)

		didChangeScreenFeedbackGenerator.impactOccurred()
	}

	func goToRootScreen(animated: Bool) {
		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.popToRootViewController(animated: animated)
		} else if let splitViewController = transitionHandler as? UISplitViewController {
			splitViewController.hideDetailViewController()
		}
	}
}
