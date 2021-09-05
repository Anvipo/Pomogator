//
//  Calendar+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

import Foundation

// MARK: - Week

extension Calendar {
	/// Возвращает дату неделю назад
	///
	/// - parameter sourceDate: дата
	/// - returns: дата неделю назад от sourceDate
	func weekAgo(from sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day], from: sourceDate)

		components.day = components.day.map { $0 - 7 }

		return date(from: components)
	}

	/// Возвращает дату неделю вперёд
	///
	/// - parameter sourceDate: дата
	/// - returns: дата неделю вперёд от sourceDate
	func nextWeek(from sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day], from: sourceDate)

		components.day = components.day.map { $0 + 7 }

		return date(from: components)
	}
}

// MARK: - Day

extension Calendar {
	/// Возвращает дату следующего дня, устанавливая время в 0:00
	///
	/// - parameter sourceDate: дата
	/// - returns: дата следующего за sourceDate дня
	func tomorrow(from sourceDate: Date) -> Date? {
		guard let tomorrow = date(byAdding: .day, value: 1, to: sourceDate) else {
			return nil
		}

		return startOfDay(for: tomorrow)
	}

	/// Возвращает дату предыдущего дня, устанавливая время в 0:00
	///
	/// - parameter sourceDate: дата
	/// - returns: дата предудыщуго дня перед sourceDate
	func yesterday(from sourceDate: Date) -> Date? {
		date(byAdding: .day, value: -1, to: sourceDate).map(startOfDay)
	}

	/// Возвращает дату, устанавливая время в 23:59:59
	///
	/// - parameter sourceDate: дата
	/// - returns: 23:59:59 того же дня
	func endOfDay(for sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day, .hour, .minute, .second], from: sourceDate)

		components.hour = 23
		components.minute = 59
		components.second = 59

		return date(from: components)
	}

	/// Возвращает дату первого числа в текущем месяце переданного Date
	///
	/// - parameter sourceDate: дата
	/// - returns: дата первого числа в текущем месяце sourceDate
	func firstDayOfMonth(from sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day], from: sourceDate)

		components.day = 1

		return date(from: components).map(startOfDay)
	}

	/// Возвращает дату последнего числа в текущем месяце переданного Date
	///
	/// - parameter sourceDate: дата
	/// - returns: дата последнего числа в текущем месяце sourceDate
	func lastDayOfMonth(from sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day], from: sourceDate)

		let daysRange = range(of: .day, in: .month, for: sourceDate)
		components.day = daysRange?.last ?? 0

		return date(from: components).flatMap(endOfDay)
	}

	/// Считает полное количество дней между указанными датами
	///
	/// - parameter fromDate: первая дата
	/// - parameter toDate: вторая дата
	/// - returns: количество дней между датами. Может быть отрицательным, если toDate меньше чем fromDate
	func daysBetweenDates(from fromDate: Date, to toDate: Date) -> Int {
		guard let fromDateInterval = dateInterval(of: .day, for: fromDate),
			  let toDateInterval = dateInterval(of: .day, for: toDate)
		else {
			return 0
		}

		let difference = dateComponents([.day], from: fromDateInterval.start, to: toDateInterval.start)

		return difference.day ?? 0
	}
}

// MARK: - Month

extension Calendar {
	/// Сравнивает 2 даты и возвращает true, если они находятся в одном и том же году и месяце
	///
	/// - parameter date1: первая дата
	/// - parameter date2: вторая дата
	/// - returns: true, если даты находятся в одном и том же году и месяце
	func isSameMonth(date1: Date, date2: Date) -> Bool {
		let components1 = dateComponents([.year, .month], from: date1)
		let components2 = dateComponents([.year, .month], from: date2)

		return components1 == components2
	}

	/// Возвращает дату первого дня следующего месяца
	///
	/// - parameter sourceDate: дата
	/// - returns: дата месяц вперед от sourceDate
	func nextMonth(from sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day], from: sourceDate)

		components.day = 1
		components.month = components.month.map { $0 + 1 }

		return date(from: components)
	}

	/// Возвращает дату первого дня предыдущего месяца
	///
	/// - parameter sourceDate: дата
	/// - returns: дата месяц назад от sourceDate
	func previousMonth(from sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day], from: sourceDate)

		components.day = 1
		components.month = components.month.map { $0 - 1 }

		return date(from: components)
	}

	/// Возвращает дату месяц вперед
	///
	/// - parameter sourceDate: дата
	/// - returns: дата месяц вперед от sourceDate
	func monthAfter(date sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day], from: sourceDate)

		components.month = components.month.map { $0 + 1 }

		return date(from: components)
	}

	/// Возвращает дату месяц назад
	///
	/// - parameter sourceDate: дата
	/// - returns: дата месяц назад от sourceDate
	func monthAgo(from sourceDate: Date) -> Date? {
		monthsAgo(1, from: sourceDate)
	}

	/// Возвращает дату 3 месяца назад
	///
	/// - parameter sourceDate: дата
	/// - returns: дата 3 месяца назад от sourceDate
	func threeMonthsAgo(from sourceDate: Date) -> Date? {
		monthsAgo(3, from: sourceDate)
	}

	/// Возвращает дату 6 месяцев назад
	///
	/// - parameter sourceDate: дата
	/// - returns: дата 6 месяцев назад от sourceDate
	func sixMonthsAgo(from sourceDate: Date) -> Date? {
		monthsAgo(6, from: sourceDate)
	}

	/// Возвращает дату months месяцев назад
	///
	/// - parameter months: количество месяцев
	/// - parameter sourceDate: дата
	/// - returns: дата months месяцев назад от sourceDate
	func monthsAgo(_ months: Int, from sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day], from: sourceDate)

		components.month = components.month.map { $0 - months }

		return date(from: components)
	}

	/// Количество затронутых месяцев между датами.
	///
	/// Пример:
	/// Для периода 24 декабря – 1 февраля вернет 3 месяца (декабрь, январь и февраль).
	func framingMonths(from startDate: Date, to endDate: Date) -> Int {
		let startMonth = firstDayOfMonth(from: startDate) ?? startDate
		let endMonth = firstDayOfMonth(from: endDate) ?? endDate

		if let period = dateComponents([.month], from: startMonth, to: endMonth).month {
			return period + 1
		} else {
			return .zero
		}
	}
}

// MARK: - Year

extension Calendar {
	/// Сравнивает 2 даты и возвращает true, если 2 года совпадают
	///
	/// - parameter date1: первая дата
	/// - parameter date2: вторая дата
	/// - returns: true, если 2 года совпадают
	func isSameYear(date1: Date, date2: Date) -> Bool {
		compare(date1, to: date2, toGranularity: .year) == .orderedSame
	}

	/// Возвращает дату год назад
	///
	/// - parameter sourceDate: дата
	/// - returns: дата год назад от sourceDate
	func yearAgo(from sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day], from: sourceDate)

		components.year = components.year.map { $0 - 1 }

		return date(from: components)
	}

	/// Возвращает дату год вперёд
	///
	/// - parameter sourceDate: дата
	/// - returns: дата год вперёд от sourceDate
	func nextYear(from sourceDate: Date) -> Date? {
		var components = dateComponents([.year, .month, .day], from: sourceDate)

		components.year = components.year.map { $0 + 1 }

		return date(from: components)
	}
}
