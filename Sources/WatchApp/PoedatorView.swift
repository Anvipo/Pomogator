//
//  PoedatorView.swift
//  WatchApp
//
//  Created by Anvipo on 09.04.2023.
//

import SwiftUI

struct PoedatorView {
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

extension PoedatorView: View {
	var body: some View {
		if mealTimeSchedule.isEmpty {
			emptyStateView
		} else {
			mealTimeScheduleView
		}
	}
}

private extension PoedatorView {
	var mealTimeScheduleView: some View {
		guard let firstMealTimeDate = mealTimeSchedule.first,
			  let lastMealTimeDate = mealTimeSchedule.last
		else {
			return AnyView(emptyStateView)
		}

		let isMealTimeScheduleInSameDay = calendar.isDate(firstMealTimeDate, inSameDayAs: lastMealTimeDate)
		let nextMealTime = mealTimeSchedule.nextMealTime

		let list = List(mealTimeSchedule, id: \.self) { mealTime in
			let text = PoedatorTextManager.format(
				mealTime: mealTime,
				addDayAndMonth: !isMealTimeScheduleInSameDay
			)

			Text(text)
				.font(.title2)
				.listRowBackground(mealTime == nextMealTime ? Color.brand.cornerRadius(8) : nil)
				.frame(maxWidth: .infinity, alignment: .center)
		}

		return AnyView(list)
	}

	var emptyStateView: some View {
		let text = PoedatorTextManager.text(for: mealTimeSchedule, calendar: calendar)

		return Text(text)
			.multilineTextAlignment(.center)
	}
}

private extension PoedatorView {
	var nextMealTime: Date? {
		mealTimeSchedule.nextMealTime
	}

	var mealTimeSchedule: PoedatorMealTimeSchedule {
		watchConnectivityFacade.poedatorMealTimeSchedule
	}
}
