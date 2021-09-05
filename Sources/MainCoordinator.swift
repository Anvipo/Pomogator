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
	private let calendar: Calendar
	private let userDefaultsFacade: UserDefaultsFacade

	init(
		appCoordinator: AppCoordinator,
		assembly: MainCoordinatorAssembly,
		calendar: Calendar,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		userDefaultsFacade: UserDefaultsFacade
	) {
		self.appCoordinator = appCoordinator
		self.assembly = assembly
		self.calendar = calendar
		self.userDefaultsFacade = userDefaultsFacade

		super.init(didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator)
	}
}

extension MainCoordinator {
	func startFlow(from transitionHandler: UIViewController) {
		self.transitionHandler = transitionHandler

		let mainVC = assembly.main(coordinator: self)

		if let navigationController = transitionHandler as? UINavigationController {
			navigationController.viewControllers = [mainVC]
		}
	}

	func goToPoedator() {
		appCoordinator.goToPoedator()
		didChangeScreenFeedbackGenerator.impactOccurred()
	}
}
