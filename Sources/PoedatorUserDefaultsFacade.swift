//
//  PoedatorUserDefaultsFacade.swift
//  Pomogator
//
//  Created by Anvipo on 22.01.2023.
//

final class PoedatorUserDefaultsFacade {
	private let userDefaultsFacade: UserDefaultsFacade

	init(userDefaultsFacade: UserDefaultsFacade) {
		self.userDefaultsFacade = userDefaultsFacade
	}
}

extension PoedatorUserDefaultsFacade {
	var mealTimeSchedule: PoedatorMealTimeSchedule {
		get {
			userDefaultsFacade.shared.dates(forKey: .mealTimeScheduleKey)
		}
		set {
			userDefaultsFacade.shared.set(newValue, forKey: .mealTimeScheduleKey)
		}
	}

	var areMealTimeScheduleRemindersAdded: Bool {
		get {
			userDefaultsFacade.local.bool(forKey: .areMealTimeScheduleRemindersAddedKey)
		}
		set {
			userDefaultsFacade.local.set(newValue, forKey: .areMealTimeScheduleRemindersAddedKey)
		}
	}
}

private extension String {
	static var mealTimeScheduleKey: Self {
		"poedator.mealTimeSchedule"
	}

	static var areMealTimeScheduleRemindersAddedKey: Self {
		"poedator.areMealTimeScheduleRemindersAdded"
	}
}
