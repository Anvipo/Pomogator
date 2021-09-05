//
//  KeyValueStoreFacade+PoedatorPreferences.swift
//  App
//
//  Created by Anvipo on 17.02.2024.
//

import Foundation

protocol IPoedatorMealTimeSchedulePreferencesStoreFacade: AnyObject {
	var inputedNumberOfMealTimes: [UInt] { get set }
	var inputedFirstMealTimes: [UInt] { get set }
	var inputedLastMealTimes: [UInt] { get set }
	var inputedShouldAutoDeleteMealSchedule: [Bool] { get set }
}

extension KeyValueStoreFacade: IPoedatorMealTimeSchedulePreferencesStoreFacade {
	var inputedNumberOfMealTimes: [UInt] {
		get {
			value(forKey: .inputedNumberOfMealTimesKey, from: [.iCloud, .local]) ?? []
		}
		set {
			var correctedNewValue = newValue

			while correctedNewValue.count > 10 {
				correctedNewValue = Array(correctedNewValue.dropFirst())
			}

			set(value: correctedNewValue, forKey: .inputedNumberOfMealTimesKey, to: [.iCloud, .local])
		}
	}

	var inputedFirstMealTimes: [UInt] {
		get {
			value(forKey: .inputedFirstMealTimesKey, from: [.iCloud, .local]) ?? []
		}
		set {
			var correctedNewValue = newValue

			while correctedNewValue.count > 10 {
				correctedNewValue = Array(correctedNewValue.dropFirst())
			}

			set(value: correctedNewValue, forKey: .inputedFirstMealTimesKey, to: [.iCloud, .local])
		}
	}

	var inputedLastMealTimes: [UInt] {
		get {
			value(forKey: .inputedLastMealTimesKey, from: [.iCloud, .local]) ?? []
		}
		set {
			var correctedNewValue = newValue

			while correctedNewValue.count > 10 {
				correctedNewValue = Array(correctedNewValue.dropFirst())
			}

			set(value: newValue, forKey: .inputedLastMealTimesKey, to: [.iCloud, .local])
		}
	}

	var inputedShouldAutoDeleteMealSchedule: [Bool] {
		get {
			value(forKey: .inputedShouldAutoDeleteMealScheduleKey, from: [.iCloud, .local]) ?? []
		}
		set {
			var correctedNewValue = newValue

			while correctedNewValue.count > 10 {
				correctedNewValue = Array(correctedNewValue.dropFirst())
			}

			set(value: newValue, forKey: .inputedShouldAutoDeleteMealScheduleKey, to: [.iCloud, .local])
		}
	}
}

private extension String {
	static var inputedNumberOfMealTimesKey: Self {
		"poedator.inputedNumberOfMealTimes"
	}

	static var inputedFirstMealTimesKey: Self {
		"poedator.inputedFirstMealTimes"
	}

	static var inputedLastMealTimesKey: Self {
		"poedator.inputedLastMealTimes"
	}

	static var inputedShouldAutoDeleteMealScheduleKey: Self {
		"poedator.inputedShouldAutoDeleteMealSchedule"
	}
}
