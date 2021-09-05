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
}
