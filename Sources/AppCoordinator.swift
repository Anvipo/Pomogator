//
//  AppCoordinator.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
	private let assembly: AppCoordinatorAssembly
	private let mainCoordinatorAssembly: MainCoordinatorAssembly
	private let poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly
	private let spotlightManager: SpotlightManager
	private let vychislyatorAssembly: VychislyatorCoordinatorAssembly

	private weak var application: UIApplication?
	private weak var appTabBarController: (IRestorable & BaseTabBarController)?
	private weak var device: UIDevice?
	private weak var window: UIWindow?
	private weak var windowScene: UIWindowScene?
	private weak var currentActiveCoordinator: BaseCoordinator?

	private var mainCoordinator: MainCoordinator?
	private var poedatorCoordinator: PoedatorCoordinator?
	private var vychislyatorCoordinator: VychislyatorCoordinator?

	init(
		application: UIApplication,
		assembly: AppCoordinatorAssembly,
		device: UIDevice,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		mainCoordinatorAssembly: MainCoordinatorAssembly,
		poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly,
		spotlightManager: SpotlightManager,
		vychislyatorAssembly: VychislyatorCoordinatorAssembly,
		window: UIWindow,
		windowScene: UIWindowScene
	) {
		self.application = application
		self.assembly = assembly
		self.device = device
		self.mainCoordinatorAssembly = mainCoordinatorAssembly
		self.poedatorCoordinatorAssembly = poedatorCoordinatorAssembly
		self.spotlightManager = spotlightManager
		self.vychislyatorAssembly = vychislyatorAssembly
		self.window = window
		self.windowScene = windowScene

		super.init(didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator)
	}
}

extension AppCoordinator {
	func startFlow(startOption: StartOption) {
		guard let window else {
			assertionFailure("?")
			return
		}

		showAppTabBar()

		switch startOption {
		case .ordinaryLaunch:
			break

		case .fromRestore(let stateRestorationActivity):
			restore(from: stateRestorationActivity)

		case .fromSpotlight(let searchableItemActivityIdentifier):
			showTab(for: searchableItemActivityIdentifier)
		}

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
			appCoordinator: self,
			windowScene: windowScene
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

		let appTabBarController = assembly.appTabBarController(output: self)
		self.appTabBarController = appTabBarController
		appTabBarController.viewControllers = [
			mainTransitionHandler,
			poedatorTransitionHandler,
			vychislyatorTransitionHandler
		]

		window.rootViewController = appTabBarController

		mainCoordinator.startFlow(from: mainTransitionHandler)
		poedatorCoordinator.startFlow(from: poedatorTransitionHandler)
		vychislyatorCoordinator.startFlow(from: vychislyatorTransitionHandler)

		indexSpotlight()
	}

	func continueFlow(searchableItemActivityIdentifier: String) {
		showTab(for: searchableItemActivityIdentifier)
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

	func goToVychislyator() {
		guard let appTabBarController,
			  let vychislyatorCoordinator
		else {
			assertionFailure("?")
			return
		}

		appTabBarController.selectedIndex = .vychislyatorTabIndex

		vychislyatorCoordinator.goToRootScreen(animated: false)
	}

	func goToDailyCalorieIntake() {
		guard let vychislyatorCoordinator else {
			assertionFailure("?")
			return
		}

		goToVychislyator()
		vychislyatorCoordinator.showDailyCalorieIntakeFormulasScreen(animated: false)
	}

	func goToBodyMassIndex() {
		guard let vychislyatorCoordinator else {
			assertionFailure("?")
			return
		}

		goToVychislyator()
		vychislyatorCoordinator.showBodyMassIndexScreen(animated: false)
	}
}

extension AppCoordinator: IRestorable {
	func saveUserActivityForRestore(to userActivity: NSUserActivity) {
		guard let currentActiveCoordinator,
			  let appTabBarController
		else {
			assertionFailure("?")
			return
		}

		appTabBarController.saveUserActivityForRestore(to: userActivity)

		guard let currentActiveCoordinator = currentActiveCoordinator as? IRestorable else {
			return
		}

		currentActiveCoordinator.saveUserActivityForRestore(to: userActivity)
	}

	func restore(from userActivity: NSUserActivity) {
		guard let appTabBarController else {
			assertionFailure("?")
			return
		}

		appTabBarController.restore(from: userActivity)

		guard let currentActiveCoordinator = currentActiveCoordinator as? IRestorable else {
			return
		}

		currentActiveCoordinator.restore(from: userActivity)
	}
}

extension AppCoordinator: IAppTabBarControllerOutput {
	func didChangeTabIndex(to newValue: Int) {
		switch newValue {
		case .mainTabIndex:
			currentActiveCoordinator = mainCoordinator

		case .poedatorTabIndex:
			currentActiveCoordinator = poedatorCoordinator

		case .vychislyatorTabIndex:
			currentActiveCoordinator = vychislyatorCoordinator

		default:
			assertionFailure("?")
		}
	}
}

private extension AppCoordinator {
	func showTab(for searchableItemActivityIdentifier: String) {
		switch searchableItemActivityIdentifier {
		case poedatorCoordinatorAssembly.spotlightSearchableUniqueIdentifier:
			goToPoedator()

		case vychislyatorAssembly.vychislyatorSpotlightSearchableUniqueIdentifier:
			goToVychislyator()

		case vychislyatorAssembly.dailyCalorieIntakeSpotlightSearchableUniqueIdentifier:
			goToDailyCalorieIntake()

		case vychislyatorAssembly.bodyMassIndexSpotlightSearchableUniqueIdentifier:
			goToBodyMassIndex()

		default:
			assertionFailure("Нужно обработать идентификатор: \(searchableItemActivityIdentifier)")
		}
	}

	func indexSpotlight() {
		Task(priority: .utility) { [weak self] in
			guard let self else {
				return
			}

			do {
				let textSearchableItems =
				self.poedatorCoordinatorAssembly.spotlightSearchableItems +
				self.vychislyatorAssembly.spotlightSearchableItems

				try await self.spotlightManager.index(textSearchableItems: textSearchableItems)
			} catch {
				assertionFailure(error.localizedDescription)
			}
		}
	}
}

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
