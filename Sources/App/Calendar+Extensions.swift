//
//  Calendar+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 29.02.2024.
//

import Foundation

extension Calendar {
	func minutesOfDay(from date: Date) -> UInt {
		let minutes = minutes(from: date)
		let hours = hours(from: date)

		return UInt(minutes + hours * 60)
	}

	func date(bySettingMinutesOfDay minutesOfDay: UInt, of date: Date) -> Date? {
		self.date(
			bySettingHour: Int(minutesOfDay) / 60,
			minute: Int(minutesOfDay) % 60,
			second: 0,
			of: date,
			matchingPolicy: .strict
		)
	}

	func dateBySettingZeroSecond(of date: Date) -> Date? {
		self.date(
			bySettingHour: hours(from: date),
			minute: minutes(from: date),
			second: 0,
			of: date,
			matchingPolicy: .strict
		)
	}

	func hours(from date: Date) -> Int {
		component(.hour, from: date)
	}

	func minutes(from date: Date) -> Int {
		component(.minute, from: date)
	}

	func seconds(from date: Date) -> Int {
		component(.second, from: date)
	}

	func minutes(from: Date, to: Date) -> Int? {
		let dateComponents = dateComponents([.minute], from: from, to: to)

		return dateComponents.minute
	}
}
