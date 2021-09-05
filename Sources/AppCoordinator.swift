//
//  AppCoordinator.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

// swiftlint:disable:next file_types_order
extension Int {
	static var mainTabIndex: Self {
		0
	}

	static var poedatorTabIndex: Self {
		1
	}
}

final class AppCoordinator: BaseCoordinator {
	private let assembly: AppCoordinatorAssembly
	private let mainCoordinatorAssembly: MainCoordinatorAssembly
	private let poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly

	private weak var application: UIApplication?
	private weak var appTabBarController: UITabBarController?
	private weak var device: UIDevice?
	private weak var window: UIWindow?
	private weak var windowScene: UIWindowScene?

	private var mainCoordinator: MainCoordinator?
	private var poedatorCoordinator: PoedatorCoordinator?

	init(
		application: UIApplication,
		assembly: AppCoordinatorAssembly,
		device: UIDevice,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly,
		mainCoordinatorAssembly: MainCoordinatorAssembly,
		window: UIWindow,
		windowScene: UIWindowScene
	) {
		self.application = application
		self.assembly = assembly
		self.device = device
		self.poedatorCoordinatorAssembly = poedatorCoordinatorAssembly
		self.mainCoordinatorAssembly = mainCoordinatorAssembly
		self.window = window
		self.windowScene = windowScene

		super.init(didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator)
	}
}

extension AppCoordinator {
	func startFlow() {
		guard let window else {
			assertionFailure("?")
			return
		}

		showAppTabBar()
		window.makeKeyAndVisible()
	}

	func showAppTabBar() {
		guard let application,
			  let device,
			  let window,
			  let windowScene
		else {
			assertionFailure("?")
			return
		}

		let (mainCoordinator, mainTransitionHandler) = mainCoordinatorAssembly.coordinatorAndTransitionHandler(
			appCoordinator: self
		)
		self.mainCoordinator = mainCoordinator

		let (poedatorCoordinator, poedatorTransitionHandler) = poedatorCoordinatorAssembly.coordinatorAndTransitionHandler(
			application: application,
			device: device,
			windowScene: windowScene
		)
		self.poedatorCoordinator = poedatorCoordinator

		let appTabBarController = assembly.appTabBarController
		self.appTabBarController = appTabBarController
		appTabBarController.viewControllers = [
			mainTransitionHandler,
			poedatorTransitionHandler
		]

		window.rootViewController = appTabBarController

		mainCoordinator.startFlow(from: mainTransitionHandler)
		poedatorCoordinator.startFlow(from: poedatorTransitionHandler)
	}

	func goToPoedator() {
		appTabBarController?.selectedIndex = .poedatorTabIndex
	}
}
