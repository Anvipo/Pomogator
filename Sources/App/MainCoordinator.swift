//
//  MainCoordinator.swift
//  App
//
//  Created by Anvipo on 15.01.2023.
//

import StoreKit
import UIKit

final class MainCoordinator: BaseCoordinator {
	private let appCoordinator: AppCoordinator
	private let assembly: MainCoordinatorAssembly

	override var flowName: String {
		String(localized: "Main screen title")
	}

	init(
		appCoordinator: AppCoordinator,
		appStore: AppStore.Type,
		assembly: MainCoordinatorAssembly,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		windowScene: UIWindowScene
	) {
		self.appCoordinator = appCoordinator
		self.assembly = assembly

		super.init(
			appStore: appStore,
			didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator,
			windowScene: windowScene
		)
	}

	override func startFlow(from transitionHandler: UIViewController) {
		super.startFlow(from: transitionHandler)

		let mainVC = assembly.main(coordinator: self)

		if let navigationController = transitionHandler as? BaseNavigationController {
			navigationController.viewControllers = [mainVC]
		} else {
			assertionFailure("?")
		}
	}
}

extension MainCoordinator {
	func goToPoedator() {
		appCoordinator.goToPoedator()
	}
}
