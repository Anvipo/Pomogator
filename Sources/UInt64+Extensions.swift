//
//  UInt64+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 10.01.2023.
//

import Foundation

extension UInt64 {
	init?(hexString: String) {
		let trimmed = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
		let scanner = Scanner(string: trimmed)

		if trimmed.hasPrefix("#") {
			scanner.currentIndex = trimmed.index(after: trimmed.startIndex)
		}

		if trimmed.count != 6 {
			return nil
		}

		var result: UInt64 = 0
		if scanner.scanHexInt64(&result) {
			self = result
		} else {
			return nil
		}
	}
}
