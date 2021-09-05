//
//  Bundle+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 24.01.2023.
//

import Foundation

extension Bundle {
	var activityTypes: [String] {
		infoDictionary?["NSUserActivityTypes"] as? [String] ?? []
	}

	var currentVersion: String? {
		guard let currentVersionRawValue = object(forInfoDictionaryKey: kCFBundleVersionKey as String),
			  let currentVersion = currentVersionRawValue as? String
		else {
			assertionFailure("Expected to find a bundle version in the info dictionary")
			return nil
		}

		return currentVersion
	}
}
