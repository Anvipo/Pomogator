//
//  Poedator.MealTimeList.CalculatorView.Model.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Combine
import Foundation
import SwiftUI
import UIKit

extension Poedator.MealTimeList.CalculatorView {
	final class Model: ObservableObject {
		init(
			storageFacade: PoedatorStorageFacadeInputProtocol,
			closeScreen: @escaping () -> Void
		) {
			self.storageFacade = storageFacade
			self.closeScreen = closeScreen

			inputedNumberOfMealTimes = 5

			inputedFirstMealTime = Date()
			inputedFirstMealTime.second = 0

			inputedLastMealTime = Date()
			inputedLastMealTime.hour = 20
			inputedLastMealTime.minute = 30
			inputedLastMealTime.second = 0

			if inputedFirstMealTime > inputedLastMealTime {
				inputedFirstMealTime.hour = 9
				inputedFirstMealTime.minute = 0
			}
		}

		private let storageFacade: PoedatorStorageFacadeInputProtocol
		private let closeScreen: () -> Void

		private var inputedNumberOfMealTimes: UInt
		private var inputedFirstMealTime: Date
		private var inputedLastMealTime: Date

		private var didInputWrongValueFeedbackGenerator: UINotificationFeedbackGenerator?
		private var didInputCorrectValueFeedbackGenerator: UISelectionFeedbackGenerator?
		// swiftlint:disable:next identifier_name
		private var didSaveCalculatedMealTimeListFeedbackGenerator: UINotificationFeedbackGenerator?
	}
}

extension Poedator.MealTimeList.CalculatorView.Model {
	func didTapSaveButton() {
//		prepareDidSaveCalculatedMealTimeListFeedbackGenerator()
//
//		storageFacade.save(calculatedMealTimeList: calculatedMealTimeList)
//		storageFacade.save(areMealTimeRemindersAdded: false)
//
//		notificateAboutDidSaveCalculatedMealTimeList()
//		clearDidSaveCalculatedMealTimeListFeedbackGenerator()

		closeScreen()
	}
}

private extension Poedator.MealTimeList.CalculatorView.Model {
	// MARK: Did input wrong value feedback generator

	func prepareDidInputWrongValueFeedbackGenerator() {
		didInputWrongValueFeedbackGenerator = UINotificationFeedbackGenerator()
		didInputWrongValueFeedbackGenerator?.prepare()
	}

	func notificateAboutDidInputWrongValue() {
		didInputWrongValueFeedbackGenerator?.notificationOccurred(.error)
	}

	func clearDidInputWrongValueFeedbackGenerator() {
		didInputWrongValueFeedbackGenerator = nil
	}

	// MARK: Did input correct value feedback generator

	func prepareDidInputCorrectValueFeedbackGenerator() {
		didInputCorrectValueFeedbackGenerator = UISelectionFeedbackGenerator()
		didInputCorrectValueFeedbackGenerator?.prepare()
	}

	func notificateAboutDidInputCorrectValue() {
		didInputCorrectValueFeedbackGenerator?.selectionChanged()
	}

	func clearDidInputCorrectValueFeedbackGenerator() {
		didInputCorrectValueFeedbackGenerator = nil
	}

	// MARK: Did save calculated meal time list feedback generator

	func prepareDidSaveCalculatedMealTimeListFeedbackGenerator() {
		didSaveCalculatedMealTimeListFeedbackGenerator = UINotificationFeedbackGenerator()
		didSaveCalculatedMealTimeListFeedbackGenerator?.prepare()
	}

	func notificateAboutDidSaveCalculatedMealTimeList() {
		didSaveCalculatedMealTimeListFeedbackGenerator?.notificationOccurred(.success)
	}

	func clearDidSaveCalculatedMealTimeListFeedbackGenerator() {
		didSaveCalculatedMealTimeListFeedbackGenerator = nil
	}

	var calculatedMealTimeList: [Date] {
		let diff = Calendar.my.dateComponents(
			[.minute],
			from: inputedFirstMealTime,
			to: inputedLastMealTime
		)
		guard let diffInMinutes = diff.minute else {
			return []
		}

		let periodInMinutes = Double(diffInMinutes) / Double(inputedNumberOfMealTimes - 1)

		var mealTimeList = [inputedFirstMealTime]
		for _ in 0..<(inputedNumberOfMealTimes - 1) {
			guard let previousMealTime = mealTimeList.last else {
				continue
			}

			let nextMealTime = previousMealTime.addingTimeInterval(periodInMinutes * 60)
			mealTimeList.append(nextMealTime)
		}

		return mealTimeList
	}
}
