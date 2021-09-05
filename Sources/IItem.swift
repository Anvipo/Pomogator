//
//  IItem.swift
//  Pomogator
//
//  Created by Anvipo on 21.08.2022.
//

import Foundation

typealias IDType = Hashable & Sendable

@MainActor
protocol IItem {
	associatedtype ID: IDType

	var id: ID { get }
}
