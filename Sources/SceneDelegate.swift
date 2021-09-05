//
//  SceneDelegate.swift
//  Pomogator
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

	var window: UIWindow?

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
			appCoordinatorAssembly: AppCoordinatorAssembly(),
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

		let window = UIWindow(windowScene: windowScene)
		self.window = window

		appCoordinator = appCoordinatorAssembly.coordinator(
			application: .shared,
			device: device,
			window: window,
			windowScene: windowScene
		)

		if connectionOptions.userActivities.isEmpty {
			willConnectSceneNotFromSpotlight(scene: scene, session: session)
		} else {
			willConnectSceneFromSpotlight(connectionOptions: connectionOptions)
		}
	}

	func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
		switch userActivity.activityType {
		case CSSearchableItemActionType:
			guard let appCoordinator,
				  let userInfo = userActivity.userInfo,
				  let uniqueIdentifier = userInfo[CSSearchableItemActivityIdentifier],
				  let uniqueIdentifierString = uniqueIdentifier as? String
			else {
				assertionFailure("?")
				return
			}

			appCoordinator.continueFlow(searchableItemActivityIdentifier: uniqueIdentifierString)

		default:
			assertionFailure("TODO: Необработанный activityType = \(userActivity.activityType)")
		}
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
			scene.userActivity = currentUserActivity
		}

		appCoordinator.saveUserActivityForRestore(to: currentUserActivity)

		return currentUserActivity
	}

	func sceneWillResignActive(_ scene: UIScene) {
		window?.windowScene?.userActivity?.resignCurrent()
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		window?.windowScene?.userActivity?.becomeCurrent()
	}
}

extension SceneDelegate: UIWindowSceneDelegate {}

private extension SceneDelegate {
	func willConnectSceneNotFromSpotlight(scene: UIScene, session: UISceneSession) {
		guard let stateRestorationActivity = session.stateRestorationActivity else {
			appCoordinator?.startFlow(startOption: .ordinaryLaunch)
			return
		}

		guard stateRestorationActivity.activityType == mainBundle.activityTypes.first,
			  stateRestorationActivity.userInfo != nil
		else {
			assertionFailure("?")
			return
		}

		scene.userActivity = stateRestorationActivity
		scene.title = stateRestorationActivity.title

		appCoordinator?.startFlow(startOption: .fromRestore(stateRestorationActivity: stateRestorationActivity))
	}

	func willConnectSceneFromSpotlight(connectionOptions: UIScene.ConnectionOptions) {
		if connectionOptions.userActivities.count == 1 {
			// swiftlint:disable:next force_unwrapping
			let userActivity = connectionOptions.userActivities.first!

			switch userActivity.activityType {
			case CSSearchableItemActionType:
				guard let appCoordinator,
					  let userInfo = userActivity.userInfo,
					  let uniqueIdentifier = userInfo[CSSearchableItemActivityIdentifier],
					  let uniqueIdentifierString = uniqueIdentifier as? String
				else {
					assertionFailure("?")
					return
				}

				appCoordinator.startFlow(startOption: .fromSpotlight(searchableItemActivityIdentifier: uniqueIdentifierString))

			default:
				assertionFailure("TODO: Необработанный activityType = \(userActivity.activityType)")
			}
		} else {
			assertionFailure("TODO: Нужно обработать несколько активити = \(connectionOptions.userActivities)")
		}
	}
}
