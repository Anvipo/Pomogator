//
//  Poedator.MealTimeListView.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import SwiftUI

extension Poedator.MealTimeList {
	struct View {
		init(viewModel: Model) {
			self.viewModel = viewModel
		}

		@ObservedObject private var viewModel: Model
	}
}

extension Poedator.MealTimeList.View: View {
	var body: some View {
		NavigationView {
			Group {
				if viewModel.mealTimeList.isEmpty {
					emptyView
				} else {
					mealTimeList
				}
			}
			.padding()
			.navigationBarTitle("Расписание приёмов пищи", displayMode: .inline)
		}
		.onAppear(perform: viewModel.onAppear)
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

private extension Poedator.MealTimeList.View {
	var emptyView: some View {
		VStack(alignment: .center) {
			Spacer()
			Text("Вы пока не составили расписание приёмов пищи")
				.font(.title)
			Spacer()

			FilledNavigationButton(
				title: "Составить расписание",
				destination: Poedator.Assembly.mealTimeListCalculatorView
			)
		}
	}

	var mealTimeList: some View {
		Group {
			Spacer()
			List(viewModel.mealTimeList) { mealTime in
				Text(mealTime.time, style: .time)
			}
			Spacer()

			if viewModel.shouldShowAddMealTimeRemindersButton {
				FilledButton(title: "Добавить напоминания", action: viewModel.didTapAddRemindersButton)
			}
		}
	}
}
