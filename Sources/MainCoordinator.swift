//
//  MainCoordinator.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit

final class MainCoordinator: BaseCoordinator {
	private let appCoordinator: AppCoordinator
	private let assembly: MainCoordinatorAssembly

	init(
		appCoordinator: AppCoordinator,
		assembly: MainCoordinatorAssembly,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator
	) {
		self.appCoordinator = appCoordinator
		self.assembly = assembly

		super.init(didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator)
	}

	override func startFlow(from transitionHandler: UIViewController) {
		super.startFlow(from: transitionHandler)

		let mainVC = assembly.main(coordinator: self)

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.viewControllers = [mainVC]
		}
	}
}

extension MainCoordinator {
	func goToPoedator() {
		appCoordinator.goToPoedator()
		didChangeScreenFeedbackGenerator.impactOccurred()
	}

	func goToDailyCalorieIntake() {
		appCoordinator.goToDailyCalorieIntake()
		didChangeScreenFeedbackGenerator.impactOccurred()
	}

	func goToBodyMassIndex() {
		appCoordinator.goToBodyMassIndex()
		didChangeScreenFeedbackGenerator.impactOccurred()
	}
}
