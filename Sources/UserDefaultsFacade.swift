//
//  UserDefaultsFacade.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//

import Foundation

final class UserDefaultsFacade {
	let local: UserDefaults
	let shared: UserDefaults

	init(
		local: UserDefaults,
		shared: UserDefaults
	) {
		self.local = local
		self.shared = shared
	}
}
