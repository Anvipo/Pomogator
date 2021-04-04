//
//  PoedatorStorageFacadeOutputProtocol.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

protocol PoedatorStorageFacadeOutputProtocol {
	var calculatedMealTimeList: [Date] { get }

	var areMealTimeRemindersAdded: Bool { get }
}
