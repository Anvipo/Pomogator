//
//  AppCoordinator.swift
//  App
//
//  Created by Anvipo on 20.09.2021.
//

import StoreKit
import UIKit

final class AppCoordinator: BaseCoordinator {
	private let assembly: AppCoordinatorAssembly
	private let mainCoordinatorAssembly: MainCoordinatorAssembly
	private let poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly
	private let spotlightManager: SpotlightManager

	private weak var application: UIApplication?
	private weak var appTabBarController: (IRestorable & BaseTabBarController)?
	private weak var device: UIDevice?
	private weak var window: BaseWindow?
	private weak var currentActiveCoordinator: BaseCoordinator?

	private var mainCoordinator: MainCoordinator?
	private var poedatorCoordinator: PoedatorCoordinator?

	init(
		application: UIApplication,
		appStore: AppStore.Type,
		assembly: AppCoordinatorAssembly,
		device: UIDevice,
		didChangeScreenFeedbackGenerator: UIImpactFeedbackGenerator,
		mainCoordinatorAssembly: MainCoordinatorAssembly,
		poedatorCoordinatorAssembly: PoedatorCoordinatorAssembly,
		spotlightManager: SpotlightManager,
		window: BaseWindow,
		windowScene: UIWindowScene
	) {
		self.application = application
		self.assembly = assembly
		self.device = device
		self.mainCoordinatorAssembly = mainCoordinatorAssembly
		self.poedatorCoordinatorAssembly = poedatorCoordinatorAssembly
		self.spotlightManager = spotlightManager
		self.window = window

		super.init(
			appStore: appStore,
			didChangeScreenFeedbackGenerator: didChangeScreenFeedbackGenerator,
			windowScene: windowScene
		)
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
		case .ordinaryLaunch: break
		case .fromRestore(let stateRestorationActivity): restore(from: stateRestorationActivity)
		case .fromSpotlight(let searchableItemActivityIdentifier): showTab(for: searchableItemActivityIdentifier)
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
			window: window,
			windowScene: windowScene
		)
		self.poedatorCoordinator = poedatorCoordinator

		let appTabBarController = assembly.appTabBarController(coordinator: self)
		self.appTabBarController = appTabBarController
		appTabBarController.viewControllers = [
			mainTransitionHandler,
			poedatorTransitionHandler
		]

		window.rootViewController = appTabBarController

		mainCoordinator.startFlow(from: mainTransitionHandler)
		poedatorCoordinator.startFlow(from: poedatorTransitionHandler)

		indexSpotlight()
	}

	func continueFlow(searchableItemActivityIdentifier: String) {
		showTab(for: searchableItemActivityIdentifier)
	}

	func didChangeTabIndex(to newValue: Int) {
		switch newValue {
		case .mainTabIndex:
			currentActiveCoordinator = mainCoordinator

		case .poedatorTabIndex:
			currentActiveCoordinator = poedatorCoordinator

		default:
			assertionFailure("?")
		}

		guard let currentActiveCoordinator else {
			assertionFailure("?")
			return
		}

		windowScene?.subtitle = currentActiveCoordinator.flowName
	}

	func goToPoedator() {
		prepareDidChangeScreenFeedbackGenerator()
		appTabBarController?.selectedIndex = .poedatorTabIndex
		triggerDidChangeScreenFeedbackGenerator()

		guard UIAccessibility.isVoiceOverRunning else {
			return
		}

		UIAccessibility.post(notification: .screenChanged, argument: nil)
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

private extension AppCoordinator {
	func showTab(for searchableItemActivityIdentifier: String) {
		switch searchableItemActivityIdentifier {
		case poedatorCoordinatorAssembly.spotlightSearchableUniqueIdentifier:
			goToPoedator()

		default:
			assertionFailure("Нужно обработать идентификатор: \(searchableItemActivityIdentifier)")
		}
	}

	func indexSpotlight() {
		let spotlightTask = Task(priority: .utility) { [weak self] in
			guard let self else {
				return
			}

			do {
				let textSearchableItems = poedatorCoordinatorAssembly.spotlightSearchableItems

				try await spotlightManager.index(textSearchableItems: textSearchableItems)
			} catch {
				assertionFailure(error.localizedDescription)
			}
		}

		tasks.append(spotlightTask)
	}
}

extension Int {
	static var mainTabIndex: Self {
		0
	}

	static var poedatorTabIndex: Self {
		1
	}
}
