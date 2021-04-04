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
		@Published var numberOfMealTimesTextFieldManager: TextFieldManager
		@Published var inputedFirstMealTime: Date {
			didSet {
//				notificateAboutDidInputCorrectValue()
//				inputedFirstMealTime.second = 0
//				didInputValue()
			}
		}
		@Published var inputedLastMealTime: Date {
			didSet {
//				notificateAboutDidInputCorrectValue()
//				inputedLastMealTime.second = 0
//				didInputValue()
			}
		}
		@Published var mealTimeList: [Poedator.MealTime]

		init(
			storageFacade: PoedatorStorageFacadeInputProtocol,
			closeScreen: @escaping () -> Void
		) {
			self.storageFacade = storageFacade
			self.closeScreen = closeScreen

			inputedNumberOfMealTimes = 5

			var inputedFirstMealTime = Date()
			inputedFirstMealTime.second = 0

			var inputedLastMealTime = Date()
			inputedLastMealTime.hour = 20
			inputedLastMealTime.minute = 30
			inputedLastMealTime.second = 0

			if inputedFirstMealTime > inputedLastMealTime {
				inputedFirstMealTime.hour = 9
				inputedFirstMealTime.minute = 0
			}
			self.inputedFirstMealTime = inputedFirstMealTime
			self.inputedLastMealTime = inputedLastMealTime

			numberOfMealTimesTextFieldManager = TextFieldManager(
				id: UUID(),
				inputedText: "\(inputedNumberOfMealTimes)"
			)

			mealTimeList = []
			didInputValue()

			numberOfMealTimesTextFieldManager.delegate = self
		}

		private let storageFacade: PoedatorStorageFacadeInputProtocol
		private let closeScreen: () -> Void

		private let numberOfMealTimesItemID = UUID()
		private let firstMealTimeItemID = UUID()
		private let lastMealTimeItemID = UUID()

		private var inputedNumberOfMealTimes: UInt

		private var didInputWrongValueFeedbackGenerator: UINotificationFeedbackGenerator?
		private var didInputCorrectValueFeedbackGenerator: UISelectionFeedbackGenerator?
		// swiftlint:disable:next identifier_name
		private var didSaveCalculatedMealTimeListFeedbackGenerator: UINotificationFeedbackGenerator?
	}
}

extension Poedator.MealTimeList.CalculatorView.Model {
	func numberOfMealTimesTextFieldDidBeginEditing() {
		prepareDidInputCorrectValueFeedbackGenerator()
		prepareDidInputWrongValueFeedbackGenerator()
	}

	func numberOfMealTimesTextFieldDidEndEditing() {
		clearDidInputCorrectValueFeedbackGenerator()
		clearDidInputWrongValueFeedbackGenerator()
	}

	func didTapSaveButton() {
		prepareDidSaveCalculatedMealTimeListFeedbackGenerator()

		storageFacade.save(calculatedMealTimeList: calculatedMealTimeList)
		storageFacade.save(areMealTimeRemindersAdded: false)

		notificateAboutDidSaveCalculatedMealTimeList()
		clearDidSaveCalculatedMealTimeListFeedbackGenerator()

		closeScreen()
	}
}

extension Poedator.MealTimeList.CalculatorView.Model: TextFieldManagerDelegate {
	func textFieldManagerShouldChange(
		_ textFieldManager: TextFieldManager,
		oldText: String,
		to newText: String
	) -> Bool {
		guard textFieldManager.id == numberOfMealTimesTextFieldManager.id else {
			return true
		}

		if newText.isEmpty {
			return true
		}

		guard let possibleNumber = UInt(newText) else {
			return false
		}

		let shouldChange = 2...9 ~= possibleNumber

		if !shouldChange {
			notificateAboutDidInputWrongValue()
		}

		return shouldChange
	}

	func textFieldManagerDidChangeText(_ textFieldManager: TextFieldManager) {
		switch textFieldManager.id {
		case numberOfMealTimesTextFieldManager.id:
			guard let newValue = UInt(textFieldManager.inputedText) else {
				notificateAboutDidInputWrongValue()
				return
			}
			inputedNumberOfMealTimes = newValue
			didInputValue()

		default:
			break
		}

		notificateAboutDidInputCorrectValue()
	}
}

//extension Poedator.MealTimeList.CalculatorView.Model {
//	func fieldsItemShouldChangeDate(
//		_ item: InputFieldDateItemProtocol,
//		newPossibleDate: Date
//	) -> Bool {
//		switch item.id {
//		case Self.firstMealTimeItemID:
//			return shouldChangeDateForFirstMealTimeItem(newPossibleDate: newPossibleDate)
//
//		case Self.lastMealTimeItemID:
//			return shouldChangeDateForLastMealTimeItem(newPossibleDate: newPossibleDate)
//
//		default:
//			return true
//		}
//	}
//
//	func fieldItem(
//		_ item: InputFieldDateItemProtocol,
//		didChange date: Date
//	) {
//		vc?.notificateAboutDidInputCorrectValue()
//
//		switch item.id {
//		case Self.firstMealTimeItemID:
//			inputedFirstMealTime = date
//			inputedFirstMealTime.second = 0
//			didInputValue()
//
//		case Self.lastMealTimeItemID:
//			inputedLastMealTime = date
//			inputedLastMealTime.second = 0
//			didInputValue()
//
//		default:
//			return
//		}
//	}
//}

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

	func didInputValue() {
		mealTimeList = calculatedMealTimeList.enumerated().map(Poedator.MealTime.init(id:time:))
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
