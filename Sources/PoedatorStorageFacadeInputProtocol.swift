//
//  PoedatorStorageFacadeInputProtocol.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

protocol PoedatorStorageFacadeInputProtocol: AnyObject {
	func save(calculatedMealTimeList: [Date])

	func save(areMealTimeRemindersAdded: Bool)
}
