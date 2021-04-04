//
//  Poedator.MealTimeList.CalculatorView.Model.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Combine

extension Poedator.MealTimeList.CalculatorView {
	final class Model: ObservableObject {
		init(
			storageFacade: PoedatorStorageFacadeOutputProtocol,
			mealRemindersManager: PoedatorMealRemindersManagerProtocol
		) {
			self.storageFacade = storageFacade
			self.mealRemindersManager = mealRemindersManager
		}

		private let storageFacade: PoedatorStorageFacadeOutputProtocol
		private let mealRemindersManager: PoedatorMealRemindersManagerProtocol
	}
}
