//
//  Locale+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import Foundation

extension Locale {
	static let my: Self = {
		if let preferredLanguage = Locale.preferredLanguages.first {
			return Self(identifier: preferredLanguage)
		}

		return autoupdatingCurrent
	}()
}
