//
//  UserDefaultsProtocol.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

protocol UserDefaultsProtocol {
	func set(dates: [Date], forKey key: String)
	func getDates(forKey key: String) -> [Date]

	func set(boolean: Bool, forKey key: String)
	func getBoolean(forKey key: String) -> Bool
}

extension UserDefaults: UserDefaultsProtocol {
	func set(dates: [Date], forKey key: String) {
		set(dates, forKey: key)
	}
	func getDates(forKey key: String) -> [Date] {
		(object(forKey: key) as? [Date]) ?? []
	}

	func set(boolean: Bool, forKey key: String) {
		set(boolean, forKey: key)
	}
	func getBoolean(forKey key: String) -> Bool {
		(object(forKey: key) as? Bool) ?? false
	}
}
