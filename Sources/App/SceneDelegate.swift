//
//  SceneDelegate.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import CoreSpotlight
import UIKit

final class SceneDelegate: UIResponder {
	private let appCoordinatorAssembly: AppCoordinatorAssembly
	private let mainBundle: Bundle

	private var appCoordinator: AppCoordinator?

	private weak var device: UIDevice?

	var window: BaseWindow?

	init(
		appCoordinatorAssembly: AppCoordinatorAssembly,
		mainBundle: Bundle,
		device: UIDevice
	) {
		self.appCoordinatorAssembly = appCoordinatorAssembly
		self.mainBundle = mainBundle
		self.device = device
	}

	override convenience init() {
		self.init(
			appCoordinatorAssembly: AppCoordinatorAssembly(dependenciesStorage: DependenciesStorage.shared),
			mainBundle: .main,
			device: .current
		)
	}
}

extension SceneDelegate: UISceneDelegate {
	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = scene as? UIWindowScene,
			  let device
		else {
			assertionFailure("?")
			return
		}

		let window = BaseWindow(windowScene: windowScene)
		self.window = window

		appCoordinator = appCoordinatorAssembly.coordinator(
			application: .shared,
			device: device,
			window: window,
			windowScene: windowScene
		)

		if let handoffUserActivityType = connectionOptions.handoffUserActivityType {
			assertionFailure("Необработанный \(handoffUserActivityType)")
		}

		if connectionOptions.userActivities.isEmpty {
			guard let stateRestorationActivity = session.stateRestorationActivity else {
				appCoordinator?.startFlow(startOption: .ordinaryLaunch)
				return
			}

			handle(userActivity: stateRestorationActivity, type: .start, for: scene)
		} else {
			for userActivity in connectionOptions.userActivities {
				handle(userActivity: userActivity, type: .start, for: scene)
			}
		}
	}

	func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
		handle(userActivity: userActivity, type: .continue, for: scene)
	}

	func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity) {
		handle(userActivity: stateRestorationActivity, type: .continue, for: scene)
	}

	func scene(_ scene: UIScene, didUpdate userActivity: NSUserActivity) {
		assertionFailure("TODO; scene = \(scene); userActivity = \(userActivity)")
	}

	func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
		guard let activityType = mainBundle.activityTypes.first,
			  let appCoordinator
		else {
			assertionFailure("?")
			return nil
		}

		let currentUserActivity: NSUserActivity
		if let sceneUserActivity = scene.userActivity {
			currentUserActivity = sceneUserActivity
		} else {
			currentUserActivity = NSUserActivity(activityType: activityType)
			currentUserActivity.isEligibleForHandoff = true
			scene.userActivity = currentUserActivity
		}

		appCoordinator.saveUserActivityForRestore(to: currentUserActivity)
		currentUserActivity.needsSave = true

		return currentUserActivity
	}

	func sceneWillResignActive(_ scene: UIScene) {
		scene.userActivity?.resignCurrent()
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		scene.userActivity?.becomeCurrent()
	}
}

extension SceneDelegate: UIWindowSceneDelegate {}

private extension SceneDelegate {
	enum HandleFlowType {
		case start
		case `continue`
	}

	func handle(
		userActivity: NSUserActivity,
		type: HandleFlowType,
		for scene: UIScene
	) {
		guard let appCoordinator else {
			assertionFailure("?")
			return
		}

		if userActivity.activityType == mainBundle.activityTypes.first {
			guard userActivity.userInfo != nil else {
				assertionFailure("?")
				return
			}

			scene.userActivity = userActivity
			scene.title = userActivity.title

			switch type {
			case .start:
				appCoordinator.startFlow(startOption: .fromRestore(stateRestorationActivity: userActivity))

			case .`continue`:
				appCoordinator.restore(from: userActivity)
			}
		} else if userActivity.activityType == CSSearchableItemActionType {
			guard let userInfo = userActivity.userInfo,
				  let uniqueIdentifier = userInfo[CSSearchableItemActivityIdentifier],
				  let uniqueIdentifierString = uniqueIdentifier as? String
			else {
				assertionFailure("?")
				return
			}

			switch type {
			case .start:
				appCoordinator.startFlow(startOption: .fromSpotlight(searchableItemActivityIdentifier: uniqueIdentifierString))

			case .`continue`:
				appCoordinator.continueFlow(searchableItemActivityIdentifier: uniqueIdentifierString)
			}
		} else if userActivity.activityType == .poedatorAppWidgetKind {
			guard let window else {
				return
			}

			if !window.isKeyWindow {
				appCoordinator.startFlow(startOption: .ordinaryLaunch)
			}

			appCoordinator.goToPoedator()
		} else {
			if userActivity.activityType.isEmpty {
				if let userInfo = userActivity.userInfo {
					assert(userInfo.isNotEmpty, "?")
				}
				return
			}

			assertionFailure("Обработать неизвестный activityType = \(userActivity.activityType)")
		}
	}
}
