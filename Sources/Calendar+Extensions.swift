//
//  Calendar+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

extension Calendar {
	static let my: Self = {
		var calendar = autoupdatingCurrent
		calendar.timeZone = .my
		calendar.locale = .my
		return calendar
	}()

	func hourAndMinuteComponents(from time: Date) -> DateComponents {
		dateComponents([.hour, .minute], from: time)
	}

	func yearComponent(from date: Date) -> Int {
		component(.year, from: date)
	}

	func monthComponent(from date: Date) -> Int {
		component(.month, from: date)
	}

	func dayComponent(from date: Date) -> Int {
		component(.day, from: date)
	}

	func hourComponent(from date: Date) -> Int {
		component(.hour, from: date)
	}

	func minuteComponent(from date: Date) -> Int {
		component(.minute, from: date)
	}

	func secondComponent(from date: Date) -> Int {
		component(.second, from: date)
	}
}
