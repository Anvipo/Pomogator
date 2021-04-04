//
//  Poedator.Assembly.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

extension Poedator {
	struct Assembly {}
}

extension Poedator.Assembly {
	static var mealTimeListView: Poedator.MealTimeList.View {
		let storageFacade = Poedator.StorageFacade(userDefaults: UserDefaults.standard)
		let viewModel = Poedator.MealTimeList.View.Model(
			storageFacade: storageFacade,
			mealRemindersManager: Poedator.MealRemindersManager(storageFacade: storageFacade)
		)

		return Poedator.MealTimeList.View(viewModel: viewModel)
	}
}

extension Poedator.Assembly {
	static var mealTimeListCalculatorView: Poedator.MealTimeList.CalculatorView {
		let storageFacade = Poedator.StorageFacade(userDefaults: UserDefaults.standard)
		let viewModel = Poedator.MealTimeList.CalculatorView.Model(
			storageFacade: storageFacade,
			mealRemindersManager: Poedator.MealRemindersManager(storageFacade: storageFacade)
		)

		return Poedator.MealTimeList.CalculatorView(viewModel: viewModel)
	}
}
