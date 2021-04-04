//
//  Date+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

extension Date {
	var dateComponents: DateComponents {
		Calendar.my.dateComponents(Calendar.Component.allCases, from: self)
	}

	var hour: UInt8 {
		get {
			UInt8(Calendar.my.hourComponent(from: self))
		}
		set {
			var dateComponentsAlternative = dateComponents
			dateComponentsAlternative.hour = Int(newValue)

			assign(dateComponents: dateComponentsAlternative)
		}
	}

	var minute: UInt8 {
		get {
			UInt8(Calendar.my.minuteComponent(from: self))
		}
		set {
			var dateComponentsAlternative = dateComponents
			dateComponentsAlternative.minute = Int(newValue)

			assign(dateComponents: dateComponentsAlternative)
		}
	}

	var second: UInt8 {
		get {
			UInt8(Calendar.my.secondComponent(from: self))
		}
		set {
			var dateComponentsAlternative = dateComponents
			dateComponentsAlternative.second = Int(newValue)

			assign(dateComponents: dateComponentsAlternative)
		}
	}
}

private extension Date {
	mutating func assign(dateComponents: DateComponents) {
		guard let changedDate = Calendar.my.date(from: dateComponents) else {
			return
		}

		self = changedDate
	}
}
