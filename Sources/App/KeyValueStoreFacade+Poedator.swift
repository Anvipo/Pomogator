//
//  KeyValueStoreFacade+Poedator.swift
//  App
//
//  Created by Anvipo on 22.01.2023.
//

protocol IPoedatorMealTimeScheduleStoreFacade: ISharedPoedatorMealTimeScheduleStoreFacade,
											   IAppSettingsStoreFacade,
											   IPoedatorMealTimeSchedulePreferencesStoreFacade {
	var areMealTimeScheduleRemindersAdded: Bool { get set }
	var mealTimeScheduleRemindersAddedCount: UInt { get set }
	var shouldAutoDeleteMealSchedule: Bool { get set }
}

extension KeyValueStoreFacade: IPoedatorMealTimeScheduleStoreFacade {
	var areMealTimeScheduleRemindersAdded: Bool {
		get {
			value(forKey: .areMealTimeScheduleRemindersAddedKey, from: [.local]) ?? false
		}
		set {
			set(value: newValue, forKey: .areMealTimeScheduleRemindersAddedKey, to: [.local])
		}
	}

	var mealTimeScheduleRemindersAddedCount: UInt {
		get {
			value(forKey: .mealTimeScheduleRemindersAddedCountKey, from: [.local]) ?? 0
		}
		set {
			set(value: newValue, forKey: .mealTimeScheduleRemindersAddedCountKey, to: [.local])
		}
	}

	var shouldAutoDeleteMealSchedule: Bool {
		get {
			value(forKey: .shouldAutoDeleteMealScheduleKey, from: [.iCloud, .local]) ?? false
		}
		set {
			set(value: newValue, forKey: .shouldAutoDeleteMealScheduleKey, to: [.iCloud, .local])
		}
	}
}

extension String {
	static var shouldAutoDeleteMealScheduleKey: Self {
		"poedator.shouldAutoDeleteMealSchedule"
	}
}

private extension String {
	static var areMealTimeScheduleRemindersAddedKey: Self {
		"poedator.areMealTimeScheduleRemindersAdded"
	}

	static var mealTimeScheduleRemindersAddedCountKey: Self {
		"poedator.mealTimeScheduleRemindersAddedCount"
	}
}
