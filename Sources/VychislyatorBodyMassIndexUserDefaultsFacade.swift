//
//  VychislyatorBodyMassIndexUserDefaultsFacade.swift
//  Pomogator
//
//  Created by Anvipo on 24.01.2023.
//

import Foundation

final class VychislyatorBodyMassIndexUserDefaultsFacade {
	private let userDefaultsFacade: UserDefaultsFacade

	init(userDefaultsFacade: UserDefaultsFacade) {
		self.userDefaultsFacade = userDefaultsFacade
	}
}

extension VychislyatorBodyMassIndexUserDefaultsFacade {
	var massInKg: Decimal? {
		get {
			userDefaultsFacade.local.decimal(forKey: .massInKgKey)
		}
		set {
			userDefaultsFacade.local.set(newValue?.nsDecimalNumber, forKey: .massInKgKey)
		}
	}

	var heightInCm: Decimal? {
		get {
			userDefaultsFacade.local.decimal(forKey: .heightInCmKey)
		}
		set {
			userDefaultsFacade.local.set(newValue?.nsDecimalNumber, forKey: .heightInCmKey)
		}
	}

	var bodyMassIndex: Decimal? {
		get {
			userDefaultsFacade.shared.decimal(forKey: .bodyMassIndexKey)
		}
		set {
			userDefaultsFacade.shared.set(newValue?.nsDecimalNumber, forKey: .bodyMassIndexKey)
		}
	}
}

private extension String {
	static var massInKgKey: Self {
		"vychislyator.bodyMassIndex.massInKg"
	}

	static var heightInCmKey: Self {
		"vychislyator.bodyMassIndex.heightInCm"
	}

	static var bodyMassIndexKey: Self {
		"vychislyator.bodyMassIndex"
	}
}
