//
//  Hasher+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

extension Hasher {
	mutating func combine<H>(_ arguments: H...) where H: Hashable {
		for argument in arguments {
			combine(argument)
		}
	}
}
