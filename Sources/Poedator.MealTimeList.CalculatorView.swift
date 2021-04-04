//
//  Poedator.MealTimeList.CalculatorView.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//
// swiftlint:disable closure_body_length

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
		VStack(alignment: .leading) {
			Section(header: Text("Параметры для составления расписания").font(.title3)) {
				Text("Количество приёмов пищи")
					.bold()
				TextField(
					"",
					text: $viewModel.numberOfMealTimesTextFieldManager.inputedText
				) { isEditing in
					if isEditing {
						viewModel.numberOfMealTimesTextFieldDidBeginEditing()
					} else {
						viewModel.numberOfMealTimesTextFieldDidEndEditing()
					}
				}
				.disableAutocorrection(true)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.keyboardType(.numberPad)

				Text("Время первого приёма пищи")
					.bold()
				DatePicker(
					selection: $viewModel.inputedFirstMealTime,
					displayedComponents: .hourAndMinute
				) { EmptyView() }
				.datePickerStyle(WheelDatePickerStyle())
				.labelsHidden()

				Text("Время последнего приёма пищи")
					.bold()
				DatePicker(
					selection: $viewModel.inputedLastMealTime,
					displayedComponents: .hourAndMinute
				) { EmptyView() }
				.datePickerStyle(WheelDatePickerStyle())
			}

			if viewModel.mealTimeList.isNotEmpty {
				Section(header: Text("Составленное расписание").font(.title3)) {
					List(viewModel.mealTimeList) { mealTime in
						Text(mealTime.time, style: .time)
					}
				}
			}

			Spacer()

			FilledButton(title: "Сохранить составленное расписание", action: viewModel.didTapSaveButton)
		}
		.padding()
		.navigationBarTitle("Составить расписание приёмов пищи", displayMode: .inline)
	}
}
