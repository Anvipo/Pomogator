//
//  VychislyatorCoordinatorAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class VychislyatorCoordinatorAssembly: BaseAssembly {}

extension VychislyatorCoordinatorAssembly: IAppTabBarCoordinatorAssembly {
	var vychislyatorSpotlightSearchableUniqueIdentifier: String {
		"vychislyator"
	}

	var dailyCalorieIntakeSpotlightSearchableUniqueIdentifier: String {
		"vychislyator.dailyCalorieIntake"
	}

	var bodyMassIndexSpotlightSearchableUniqueIdentifier: String {
		"vychislyator.bodyMassIndex"
	}

	var spotlightSearchableItems: [SpotlightSearchableItem] {
		let vychislyatorSpotlightSearchableItem = {
			let title = String(localized: "Vychislyator")
			let keywords = [
				title,
				String(localized: "Fitness spotlight keyword"),
				String(localized: "Formula spotlight keyword"),
				String(localized: "Calculator spotlight keyword")
			]

			return defaultSpotlightSearchableItem(
				contentDescription: String(localized: "Vychislyator spotlight content description"),
				keywords: keywords,
				thumbnailData: Image.vychislyator.uiImage.pngData(),
				title: title,
				uniqueIdentifier: vychislyatorSpotlightSearchableUniqueIdentifier
			)
		}()

		let dailyCalorieIntakeSpotlightSearchableItem = {
			let title = String(localized: "Daily calorie intake")
			let keywords = [
				title,
				String(localized: "Fitness spotlight keyword"),
				String(localized: "Calories spotlight keyword"),
				String(localized: "Formula spotlight keyword"),
				String(localized: "Calculator spotlight keyword"),
				String(localized: "Daily calorie intake spotlight keyword")
			]

			return defaultSpotlightSearchableItem(
				contentDescription: String(localized: "Daily calorie intake spotlight content description"),
				keywords: keywords,
				thumbnailData: Image.vychislyator.uiImage.pngData(),
				title: title,
				uniqueIdentifier: dailyCalorieIntakeSpotlightSearchableUniqueIdentifier
			)
		}()

		let bodyMassIndexSpotlightSearchableItem = {
			let title = String(localized: "Body mass index")
			let keywords = [
				title,
				String(localized: "Fitness spotlight keyword"),
				String(localized: "Formula spotlight keyword"),
				String(localized: "Calculator spotlight keyword"),
				String(localized: "Body mass index spotlight keyword"),
				String(localized: "BMI spotlight keyword")
			]

			return defaultSpotlightSearchableItem(
				contentDescription: String(localized: "Body mass index spotlight content description"),
				keywords: keywords,
				thumbnailData: Image.vychislyator.uiImage.pngData(),
				title: title,
				uniqueIdentifier: bodyMassIndexSpotlightSearchableUniqueIdentifier
			)
		}()

		return [
			vychislyatorSpotlightSearchableItem,
			dailyCalorieIntakeSpotlightSearchableItem,
			bodyMassIndexSpotlightSearchableItem
		]
	}
}

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
				userDefaultsFacade: VychislyatorDailyCalorieIntakeUserDefaultsFacade(userDefaultsFacade: dependenciesStorage.userDefaultsFacade)
			),
			transitionHandler
		)
	}

	func formulasList(coordinator: VychislyatorCoordinator) -> BaseVC {
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
	) -> BaseVC {
		let presenter = VychislyatorDailyCalorieIntakeFormulasListPresenter(
			assembly: VychislyatorDailyCalorieIntakeFormulasListAssembly(),
			coordinator: coordinator,
			didTapBarButtonItemFeedbackGenerator: dependenciesStorage.didTapBarButtonItemFeedbackGenerator,
			didTapFieldViewFeedbackGenerator: dependenciesStorage.didTapFieldViewFeedbackGenerator,
			mifflinStJeorCalculator: MifflinStJeorCalculator(),
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			userDefaultsFacade: VychislyatorDailyCalorieIntakeUserDefaultsFacade(userDefaultsFacade: dependenciesStorage.userDefaultsFacade),
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
		currentMassInKg: Decimal?,
		currentHeightInCm: Decimal?
	) -> BaseVC {
		let presenter = VychislyatorBodyMassIndexPresenter(
			assembly: VychislyatorBodyMassIndexAssembly(),
			bodyMassIndexCalculator: BodyMassIndexCalculator(),
			coordinator: coordinator,
			didTapBarButtonItemFeedbackGenerator: dependenciesStorage.didTapBarButtonItemFeedbackGenerator,
			didTapFieldViewFeedbackGenerator: dependenciesStorage.didTapFieldViewFeedbackGenerator,
			currentMassInKg: currentMassInKg,
			currentHeightInCm: currentHeightInCm,
			notificationFeedbackGenerator: UINotificationFeedbackGenerator(),
			userDefaultsFacade: VychislyatorBodyMassIndexUserDefaultsFacade(userDefaultsFacade: dependenciesStorage.userDefaultsFacade)
		)
		let view = VychislyatorBodyMassIndexVC(presenter: presenter)
		presenter.set(view: view)

		return view
	}
}
