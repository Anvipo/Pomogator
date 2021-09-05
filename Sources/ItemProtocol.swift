//
//  ItemProtocol.swift
//  Pomogator
//
//  Created by Anvipo on 21.08.2022.
//

import Foundation

protocol ItemProtocol {
	associatedtype ID: Hashable

	var id: ID { get }
}
