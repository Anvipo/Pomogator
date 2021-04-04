//
//  Poedator.Assembly.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Combine
import Foundation
import SwiftUI

extension Poedator {
	struct Assembly {}
}

extension Poedator.Assembly {
	static var mealTimeListView: some View {
		let storageFacade = Poedator.StorageFacade(userDefaults: UserDefaults.standard)
		let viewModel = Poedator.MealTimeList.View.Model(
			storageFacade: storageFacade,
			mealRemindersManager: Poedator.MealRemindersManager(storageFacade: storageFacade)
		)

		return Poedator.MealTimeList.View(viewModel: viewModel)
	}
}

extension Poedator.Assembly {
	static func mealTimeListCalculatorView(closeScreen: @escaping () -> Void) -> some View {
		let viewModel = Poedator.MealTimeList.CalculatorView.Model(
			storageFacade: Poedator.StorageFacade(userDefaults: UserDefaults.standard),
			closeScreen: closeScreen
		)

		return Poedator.MealTimeList.CalculatorView(viewModel: viewModel)
	}
}
