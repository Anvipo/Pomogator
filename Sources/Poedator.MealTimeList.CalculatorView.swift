//
//  Poedator.MealTimeList.CalculatorView.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import SwiftUI

extension Poedator.MealTimeList {
	struct CalculatorView {
		init(viewModel: Model) {
			self.viewModel = viewModel
		}

		@ObservedObject private var viewModel: Model
	}
}

extension Poedator.MealTimeList.CalculatorView: View {
	var body: some View {
		Group {
			Text("2")
		}
		.padding()
		.navigationBarTitle("Составить расписание приёмов пищи", displayMode: .inline)
	}
}
