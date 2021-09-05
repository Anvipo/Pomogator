//
//  MainView.swift
//  WatchApp
//
//  Created by Anvipo on 08.04.2023.
//

import SwiftUI

struct MainView {
	private let calendar: Calendar
	@ObservedObject private var watchConnectivityFacade: WatchConnectivityFacade

	init(
		calendar: Calendar,
		watchConnectivityFacade: WatchConnectivityFacade
	) {
		self.calendar = calendar
		self.watchConnectivityFacade = watchConnectivityFacade
	}
}

extension MainView: View {
	var body: some View {
		Group {
			let text = PoedatorTextManager.text(
				for: poedatorMealTimeSchedule,
				calendar: calendar
			)

			if let nextMealTime {
				let title = String(localized: "Poedator main title")

				VStack {
					Text(title)
						.font(.caption)
						.multilineTextAlignment(.center)

					Text(text)
						.font(calendar.isDateInToday(nextMealTime) ? .title : nil)
				}
				.accessibilityElement(children: .combine)
				.accessibilityLabel(Text(title))
				.accessibilityValue(Text(text))
			} else {
				Text(text)
					.multilineTextAlignment(.center)
					.accessibilityValue(Text(text))
			}
		}
	}
}

private extension MainView {
	var nextMealTime: Date? {
		poedatorMealTimeSchedule.nextMealTime
	}

	var poedatorMealTimeSchedule: PoedatorMealTimeSchedule {
		watchConnectivityFacade.poedatorMealTimeSchedule
	}
}
