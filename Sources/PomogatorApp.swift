//
//  PomogatorApp.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import SwiftUI

@main
struct PomogatorApp {
	// swiftlint:disable:next weak_delegate
	@UIApplicationDelegateAdaptor private var appDelegate: PomogatorApplicationDelegate
}

extension PomogatorApp: App {
	var body: some Scene {
		WindowGroup {
			MainView()
		}
	}
}
