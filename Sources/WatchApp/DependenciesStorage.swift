//
//  DependenciesStorage.swift
//  WatchApp
//
//  Created by Anvipo on 08.04.2023.
//

import Foundation

final class DependenciesStorage {
	let calendar: Calendar
	let keyValueStoreFacade: KeyValueStoreFacade
	let watchConnectivityFacade: WatchConnectivityFacade

	private init() {
		calendar = .pomogator

		keyValueStoreFacade = KeyValueStoreFacade(
			iCloud: NSUbiquitousKeyValueStore.default,
			local: UserDefaults.standard,
			shared: UserDefaults.sharedWithWidget
		)

		watchConnectivityFacade = WatchConnectivityFacade(
			keyValueStoreFacade: keyValueStoreFacade,
			wcSession: .default,
			widgetCenter: .shared
		)
	}
}

extension DependenciesStorage {
	static let shared = DependenciesStorage()
}
