//
//  Poedator.MealTime.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

extension Poedator {
	struct MealTime {
		let id: Int

		let time: Date
	}
}

extension Poedator.MealTime: Identifiable {}
