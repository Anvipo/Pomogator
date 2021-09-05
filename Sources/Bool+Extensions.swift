//
//  Bool+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

extension Bool {
	var stringValue: String {
		self ? "true" : "false"
	}

	var intValue: Int {
		self ? 1 : 0
	}
}
