//
//  WatchApp.swift
//  WatchApp
//
//  Created by Anvipo on 08.04.2023.
//

import SwiftUI

@main
struct WatchApp {
	private let dependenciesStorage: DependenciesStorage
	@ObservedObject private var watchConnectivityFacade: WatchConnectivityFacade
	private let transition = AnyTransition.opacity.animation(.default)

	init() {
		dependenciesStorage = .shared

		watchConnectivityFacade = dependenciesStorage.watchConnectivityFacade

		watchConnectivityFacade.start()
	}
}

extension WatchApp: App {
	var body: some Scene {
		WindowGroup {
			let calendar = dependenciesStorage.calendar

			if mealTimeSchedule.isEmpty {
				MainView(calendar: calendar, watchConnectivityFacade: watchConnectivityFacade)
					.transition(transition)
			} else {
				TabView {
					MainView(calendar: calendar, watchConnectivityFacade: watchConnectivityFacade)

					NavigationStack {
						PoedatorView(calendar: calendar, watchConnectivityFacade: watchConnectivityFacade)
							.navigationTitle("Poedator navigation title")
							.navigationBarTitleDisplayMode(.large)
					}
				}
				.transition(transition)
			}
		}
	}
}

private extension WatchApp {
	var nextMealTime: Date? {
		mealTimeSchedule.nextMealTime
	}

	var mealTimeSchedule: PoedatorMealTimeSchedule {
		watchConnectivityFacade.poedatorMealTimeSchedule
	}
}
