//
//  Array+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 07.01.2023.
//

extension Array {
	var nonEmptyOrNil: Self? {
		isEmpty ? nil : self
	}
}
