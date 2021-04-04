//
//  Calendar.Component+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

extension Calendar.Component: CaseIterable {
	public typealias AllCases = Set<Self>

	public static var allCases: AllCases {
		[
			.calendar,
			.timeZone,
			.era,
			.year,
			.month,
			.day,
			.hour,
			.minute,
			.second,
			.nanosecond,
			.weekday,
			.weekdayOrdinal,
			.quarter,
			.weekOfMonth,
			.weekOfYear,
			.yearForWeekOfYear
		]
	}
}
