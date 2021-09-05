//
//  AppCoordinator.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//
// swiftlint:disable file_types_order

import UIKit

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
	private let device: UIDevice
	private let mainCoordinatorAssembly: MainCoordinatorAssembly
	private let poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly
	private let screen: UIScreen

	private weak var application: UIApplication?
	private weak var appTabBarController: UITabBarController?
	private weak var window: UIWindow?

	private var mainCoordinator: MainCoordinator?
	private var poedatorCoordinator: PoedatorCoordinator?

	init(
		application: UIApplication,
		assembly: AppCoordinatorAssembly,
		device: UIDevice,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly,
		mainCoordinatorAssembly: MainCoordinatorAssembly,
		screen: UIScreen,
		window: UIWindow
	) {
		self.application = application
		self.assembly = assembly
		self.device = device
		self.poedatorCoordinatorAssembly = poedatorCoordinatorAssembly
		self.mainCoordinatorAssembly = mainCoordinatorAssembly
		self.screen = screen
		self.window = window

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
		guard let window,
			  let application
		else {
			assertionFailure("?")
			return
		}

		let (mainCoordinator, mainTransitionHandler) = mainCoordinatorAssembly.coordinatorAndTransitionHandler(
			appCoordinator: self,
			device: device,
			screen: screen
		)
		self.mainCoordinator = mainCoordinator

		let (poedatorCoordinator, poedatorTransitionHandler) = poedatorCoordinatorAssembly.coordinatorAndTransitionHandler(
			application: application,
			device: device,
			screen: screen
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
