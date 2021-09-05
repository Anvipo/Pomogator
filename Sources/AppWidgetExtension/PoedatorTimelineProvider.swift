//
//  PoedatorTimelineProvider.swift
//  AppWidgetExtension
//
//  Created by Anvipo on 09.03.2023.
//

import Foundation
import WidgetKit

struct PoedatorTimelineProvider {
	private let sharedPoedatorMealTimeScheduleStoreFacade: ISharedPoedatorMealTimeScheduleStoreFacade

	init(sharedPoedatorMealTimeScheduleStoreFacade: ISharedPoedatorMealTimeScheduleStoreFacade) {
		self.sharedPoedatorMealTimeScheduleStoreFacade = sharedPoedatorMealTimeScheduleStoreFacade
	}
}

// swiftlint:disable unused_parameter
extension PoedatorTimelineProvider: TimelineProvider {
	typealias Entry = PoedatorTimelineEntry

	func placeholder(in: Context) -> Entry {
		Entry(date: .now, nextMealTime: nextMealTime)
	}

	func getSnapshot(in: Context, completion: @escaping (Entry) -> Void) {
		let entry = Entry(date: .now, nextMealTime: .now)
		completion(entry)
	}

	func getTimeline(in: Context, completion: @escaping (Timeline<Entry>) -> Void) {
		let policy: TimelineReloadPolicy =
		if let nextMealTime {
			.after(nextMealTime)
		} else {
			.atEnd
		}

		let entry = Entry(date: .now, nextMealTime: nextMealTime)
		completion(Timeline(entries: [entry], policy: policy))
	}
}
// swiftlint:enable unused_parameter

private extension PoedatorTimelineProvider {
	var nextMealTime: Date? {
		sharedPoedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.sharedLocal]).nextMealTime
	}
}
