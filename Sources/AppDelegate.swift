//
//  AppDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

@main
final class AppDelegate: UIResponder {
	private let userNotificationCenter: UNUserNotificationCenter
	private let userNotificationCenterFacade: UserNotificationCenterFacade

	init(
		userNotificationCenter: UNUserNotificationCenter,
		userNotificationCenterFacade: UserNotificationCenterFacade
	) {
		self.userNotificationCenter = userNotificationCenter
		self.userNotificationCenterFacade = userNotificationCenterFacade
	}

	override convenience init() {
		self.init(
			userNotificationCenter: .current(),
			userNotificationCenterFacade: DependenciesStorage.shared.userNotificationCenterFacade
		)
	}
}

extension AppDelegate: UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		// swiftlint:disable:next discouraged_optional_collection
		willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		userNotificationCenter.delegate = userNotificationCenterFacade

		return true
	}
}
