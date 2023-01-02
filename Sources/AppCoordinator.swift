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

	static var vychislyatorTabIndex: Self {
		2
	}
}

final class AppCoordinator: BaseCoordinator {
	private let assembly: AppCoordinatorAssembly
	private let mainCoordinatorAssembly: MainCoordinatorAssembly
	private let poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly
	private let userDefaultsFacade: UserDefaultsFacade
	private let vychislyatorAssembly: VychislyatorCoordinatorAssembly

	private weak var application: UIApplication?
	private weak var appTabBarController: UITabBarController?
	private weak var device: UIDevice?
	private weak var window: Window?
	private weak var windowScene: UIWindowScene?

	private var mainCoordinator: MainCoordinator?
	private var poedatorCoordinator: PoedatorCoordinator?
	private var vychislyatorCoordinator: VychislyatorCoordinator?

	init(
		application: UIApplication,
		assembly: AppCoordinatorAssembly,
		device: UIDevice,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly,
		mainCoordinatorAssembly: MainCoordinatorAssembly,
		userDefaultsFacade: UserDefaultsFacade,
		vychislyatorAssembly: VychislyatorCoordinatorAssembly,
		window: Window,
		windowScene: UIWindowScene
	) {
		self.application = application
		self.assembly = assembly
		self.device = device
		self.poedatorCoordinatorAssembly = poedatorCoordinatorAssembly
		self.mainCoordinatorAssembly = mainCoordinatorAssembly
		self.userDefaultsFacade = userDefaultsFacade
		self.vychislyatorAssembly = vychislyatorAssembly
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

		window.rootViewController = assembly.splashScreenVC { [weak self] in
			self?.showAfterSplashScreen()
		}
		window.makeKeyAndVisible()
		window.addFadeTransition()
	}

	func showAfterSplashScreen() {
		guard let window,
			  let windowScene
		else {
			assertionFailure("?")
			return
		}

		if userDefaultsFacade.userWasOnboarded {
			showAppTabBar()
		} else {
			window.rootViewController = OnboardingRootVC(
				screen: windowScene.screen,
				buttonSelectionFeedbackGenerator: UISelectionFeedbackGenerator(),
				pageControlSelectionFeedbackGenerator: UISelectionFeedbackGenerator()
			) { [weak self] in
				self?.userDefaultsFacade.userWasOnboarded = true

				self?.didChangeScreenFeedbackGenerator.prepare()
				self?.showAppTabBar {
					self?.didChangeScreenFeedbackGenerator.impactOccurred()
				}
			}
		}
	}

	func showAppTabBar(completion: (() -> Void)? = nil) {
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

		let (vychislyatorCoordinator, vychislyatorTransitionHandler) = vychislyatorAssembly.coordinatorAndTransitionHandler(
			device: device,
			windowScene: windowScene
		)
		self.vychislyatorCoordinator = vychislyatorCoordinator

		let appTabBarController = assembly.appTabBarController
		self.appTabBarController = appTabBarController
		appTabBarController.viewControllers = [
			mainTransitionHandler,
			poedatorTransitionHandler,
			vychislyatorTransitionHandler
		]

		window.rootViewController = appTabBarController
		// swiftlint:disable:next trailing_closure
		window.addFadeTransition(completion: { _ in
			completion?()
		})

		mainCoordinator.startFlow(from: mainTransitionHandler)
		poedatorCoordinator.startFlow(from: poedatorTransitionHandler)
		vychislyatorCoordinator.startFlow(from: vychislyatorTransitionHandler)

		window.responderDelegate = self
	}
}

extension AppCoordinator: UIResponderDelegate {
	func shakeBegan() {
		didChangeScreenFeedbackGenerator.prepare()
	}

	func shakeEnded() {
		guard let rootViewController = window?.rootViewController else {
			assertionFailure("?")
			return
		}

		let pomogatorFaceVC = PomogatorFaceVC()
		pomogatorFaceVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: Image.xmarkCircleFill.uiImage,
			primaryAction: UIAction { [weak self] _ in
				self?.window?.rootViewController?.presentedViewController?.dismiss(animated: true)
			}
		).apply { barButtonItem in
			barButtonItem.tintColor = Color.white.uiColor
		}

		let navigationController = PomogatorFaceNC(rootViewController: pomogatorFaceVC)

		rootViewController.present(navigationController, animated: true)

		didChangeScreenFeedbackGenerator.impactOccurred()
	}

	func goToPoedator() {
		guard let appTabBarController,
			  let poedatorCoordinator
		else {
			assertionFailure("?")
			return
		}

		appTabBarController.selectedIndex = .poedatorTabIndex
		poedatorCoordinator.goToRootScreen(animated: false)
	}

	func goToDailyCalorieIntake() {
		guard let appTabBarController,
			  let vychislyatorCoordinator
		else {
			assertionFailure("?")
			return
		}

		appTabBarController.selectedIndex = .vychislyatorTabIndex

		vychislyatorCoordinator.goToRootScreen(animated: false)
		vychislyatorCoordinator.showDailyCalorieIntakeFormulasScreen(animated: false)
	}

	func goToBodyMassIndex() {
		guard let appTabBarController,
			  let vychislyatorCoordinator
		else {
			assertionFailure("?")
			return
		}

		appTabBarController.selectedIndex = .vychislyatorTabIndex

		vychislyatorCoordinator.goToRootScreen(animated: false)
		vychislyatorCoordinator.showBodyMassIndexScreen(animated: false)
	}
}
