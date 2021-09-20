//
//  VychislyatorCoordinatorAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class VychislyatorCoordinatorAssembly: BaseAssembly {}

extension VychislyatorCoordinatorAssembly {
	func coordinatorAndTransitionHandler(
		device: UIDevice,
		windowScene: UIWindowScene
	) -> (VychislyatorCoordinator, UIViewController) {
		let transitionHandler: UIViewController
		if device.userInterfaceIdiom == .pad {
			let splitViewController = UISplitViewController()
			// чтобы в вертикальной ориентации тоже было разбиение на master и details
			splitViewController.preferredDisplayMode = .oneBesideSecondary
			splitViewController.preferredPrimaryColumnWidthFraction = 0.5
			splitViewController.maximumPrimaryColumnWidth = windowScene.screen.bounds.width / 2

			transitionHandler = splitViewController
		} else {
			let navigationController = UINavigationController()
			navigationController.navigationBar.tintColor = Color.brand.uiColor

			transitionHandler = navigationController
		}
		transitionHandler.tabBarItem = UITabBarItem(
			title: String(localized: "Vychislyator"),
			// swiftlint:disable:next force_try
			image: try! Image.vychislyator.proportionallyResizedImage(to: .init(side: 25)),
			tag: .vychislyatorTabIndex
		)

		return (
			VychislyatorCoordinator(
				assembly: VychislyatorCoordinatorAssembly(),
				didChangeScreenFeedbackGenerator: dependenciesStorage.didChangeScreenFeedbackGenerator,
				userDefaultsFacade: dependenciesStorage.userDefaultsFacade
			),
			transitionHandler
		)
	}

	func formulasList(coordinator: VychislyatorCoordinator) -> UIViewController {
		let presenter = VychislyatorFormulasListPresenter(
			assembly: VychislyatorFormulasListAssembly(),
			coordinator: coordinator
		)
		let view = VychislyatorFormulasListVC(presenter: presenter)
		presenter.set(view: view)

		return view
	}

	// swiftlint:disable:next function_parameter_count
	func dailyCalorieIntakeFormulasList(
		coordinator: VychislyatorCoordinator,
		personSexes: [PersonSex],
		selectedPersonSex: PersonSex,
		inputedAgeInYears: UInt?,
		inputedHeightInCm: Decimal?,
		inputedMassInKg: Decimal?,
		physicalActivities: [PhysicalActivity],
		selectedPhysicalActivity: PhysicalActivity
	) -> UIViewController {
		let presenter = VychislyatorDailyCalorieIntakeFormulasListPresenter(
			assembly: VychislyatorDailyCalorieIntakeFormulasListAssembly(),
			coordinator: coordinator,
			didTapBarButtonItemFeedbackGenerator: dependenciesStorage.didTapBarButtonItemFeedbackGenerator,
			didTapFieldViewFeedbackGenerator: dependenciesStorage.didTapFieldViewFeedbackGenerator,
			mifflinStJeorCalculator: MifflinStJeorCalculator(),
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			userDefaultsFacade: dependenciesStorage.userDefaultsFacade,
			personSexes: personSexes,
			selectedPersonSex: selectedPersonSex,
			inputedAgeInYears: inputedAgeInYears,
			inputedHeightInCm: inputedHeightInCm,
			inputedMassInKg: inputedMassInKg,
			physicalActivities: physicalActivities,
			selectedPhysicalActivity: selectedPhysicalActivity
		)
		let view = VychislyatorDailyCalorieIntakeFormulasListVC(presenter: presenter)
		presenter.set(view: view)

		return view
	}

	func bodyMassIndex(
		coordinator: VychislyatorCoordinator,
		inputedMassInKg: Decimal?,
		inputedHeightInCm: Decimal?
	) -> UIViewController {
		let presenter = VychislyatorBodyMassIndexPresenter(
			assembly: VychislyatorBodyMassIndexAssembly(),
			bodyMassIndexCalculator: BodyMassIndexCalculator(),
			coordinator: coordinator,
			didTapBarButtonItemFeedbackGenerator: dependenciesStorage.didTapBarButtonItemFeedbackGenerator,
			didTapFieldViewFeedbackGenerator: dependenciesStorage.didTapFieldViewFeedbackGenerator,
			inputedMassInKg: inputedMassInKg,
			inputedHeightInCm: inputedHeightInCm,
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			userDefaultsFacade: dependenciesStorage.userDefaultsFacade
		)
		let view = VychislyatorBodyMassIndexVC(presenter: presenter)
		presenter.set(view: view)

		return view
	}
}
