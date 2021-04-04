//
//  PomogatorApplicationDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import UIKit

final class PomogatorApplicationDelegate: NSObject {}

extension PomogatorApplicationDelegate: UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		// swiftlint:disable:next discouraged_optional_collection
		willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		UNUserNotificationCenter.current().delegate =
		UserNotificationCenterFacade.shared as? UNUserNotificationCenterDelegate

		return true
	}
}
