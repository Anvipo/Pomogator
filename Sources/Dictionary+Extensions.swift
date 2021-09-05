//
//  Dictionary+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

import Foundation

extension Dictionary {
	var prettyFormatted: String {
		if let data = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]),
		   let dataString = String(data: data, encoding: .utf8) {
			return dataString
		} else {
			return String(describing: self)
		}
	}
}
