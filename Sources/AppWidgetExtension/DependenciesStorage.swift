//
//  DependenciesStorage.swift
//  AppWidgetExtension
//
//  Created by Anvipo on 10.04.2023.
//

import Foundation

final class DependenciesStorage {
	let calendar: Calendar
	let keyValueStoreFacade: KeyValueStoreFacade

	private init() {
		calendar = .pomogator

		keyValueStoreFacade = KeyValueStoreFacade(
			iCloud: NSUbiquitousKeyValueStore.default,
			local: UserDefaults.standard,
			shared: UserDefaults.sharedWithWidget
		)
	}
}

extension DependenciesStorage {
	static let shared = DependenciesStorage()
}
