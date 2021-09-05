//
//  SharedPoedator.swift
//  App
//
//  Created by Anvipo on 10.03.2023.
//

import SwiftUI

typealias PoedatorMealTimeSchedule = [Date]

enum PoedatorTextManager {}

extension PoedatorTextManager {
	static func format(mealTime: Date, addDayAndMonth: Bool, forVoiceOver: Bool = false) -> String {
		if forVoiceOver {
			var neededCalendarComponents: [Calendar.Component] = [.hour, .minute]
			if addDayAndMonth {
				neededCalendarComponents += [.day, .month]
			}
			let dateComponents = Calendar.pomogator.dateComponents(Set(neededCalendarComponents), from: mealTime)
			return DateComponentsFormatter.localizedString(from: dateComponents, unitsStyle: .full) ?? ""
		}

		var dateFormatStyle = Date.FormatStyle().hour().minute()
		if addDayAndMonth {
			dateFormatStyle = dateFormatStyle.day().month(.wide)
		}

		return mealTime.formatted(dateFormatStyle)
	}

	static func text(
		for mealTimeSchedule: PoedatorMealTimeSchedule,
		calendar: Calendar,
		forVoiceOver: Bool = false
	) -> String {
		if mealTimeSchedule.isEmpty {
			return String(localized: "No saved meal time schedule text")
		}

		let isMealTimeScheduleInSameDay = isMealTimeScheduleInSameDay(
			calendar: calendar,
			mealTimeSchedule: mealTimeSchedule
		)
		let isMealTimeScheduleInToday = isMealTimeScheduleInToday(
			calendar: calendar,
			mealTimeSchedule: mealTimeSchedule
		)

		if let nextMealTime = mealTimeSchedule.nextMealTime {
			return format(
				mealTime: nextMealTime,
				addDayAndMonth: !calendar.isDateInToday(nextMealTime),
				forVoiceOver: forVoiceOver
			)
		}

		if isMealTimeScheduleInSameDay && isMealTimeScheduleInToday {
			return String(localized: "No saved meal time schedule for today main text")
		}

		return String(localized: "No saved meal time actual schedule main text")
	}
}

extension PoedatorTextManager {
	static func isMealTimeScheduleInSameDay(
		calendar: Calendar,
		mealTimeSchedule: PoedatorMealTimeSchedule
	) -> Bool {
		guard let firstMealTimeDate = mealTimeSchedule.first,
			  let lastMealTimeDate = mealTimeSchedule.last
		else { return false }

		return calendar.isDate(firstMealTimeDate, inSameDayAs: lastMealTimeDate)
	}

	static func isMealTimeScheduleInToday(
		calendar: Calendar,
		mealTimeSchedule: PoedatorMealTimeSchedule
	) -> Bool {
		guard let firstMealTimeDate = mealTimeSchedule.first
		else { return false }

		return isMealTimeScheduleInSameDay(calendar: calendar, mealTimeSchedule: mealTimeSchedule) &&
			   calendar.isDateInToday(firstMealTimeDate)
	}
}

extension String {
	static var poedatorAppWidgetKind: Self {
		"PoedatorAppWidget"
	}

	static var poedatorMealTimeScheduleKey: Self {
		"poedator.mealTimeSchedule"
	}
}

extension PoedatorMealTimeSchedule {
	var isOutdated: Bool {
		allSatisfy { $0.timeIntervalSinceNow <= 0 }
	}

	var nextMealTime: Date? {
		nearest(from: .now)
	}

	private func nearest(from date: Element) -> Element? {
		sorted().first { $0.timeIntervalSince(date) > 0 }
	}
}

protocol ISharedPoedatorMealTimeScheduleStoreFacade: AnyObject {
	func poedatorMealTimeSchedule(from sourceTypes: [KeyValueStoreFacade.SourceType]) -> PoedatorMealTimeSchedule
	func save(poedatorMealTimeSchedule: PoedatorMealTimeSchedule, to sourceTypes: [KeyValueStoreFacade.SourceType])
}

extension KeyValueStoreFacade: ISharedPoedatorMealTimeScheduleStoreFacade {
	func poedatorMealTimeSchedule(from sourceTypes: [SourceType]) -> PoedatorMealTimeSchedule {
		value(forKey: .poedatorMealTimeScheduleKey, from: sourceTypes) ?? []
	}

	func save(poedatorMealTimeSchedule: PoedatorMealTimeSchedule, to sourceTypes: [SourceType]) {
		set(value: poedatorMealTimeSchedule, forKey: .poedatorMealTimeScheduleKey, to: sourceTypes)
	}
}
