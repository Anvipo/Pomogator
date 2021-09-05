//
//  IItem.swift
//  App
//
//  Created by Anvipo on 21.08.2022.
//

import Foundation

typealias IDType = Hashable

protocol IItem {
	associatedtype ID: IDType

	var id: ID { get }
}
