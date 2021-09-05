//
//  DateFieldItem.Content.swift
//  App
//
//  Created by Anvipo on 11.09.2021.
//

import Foundation

extension DateFieldItem {
	struct Content: Hashable {
		let icon: Image
		let title: String
		var value: Date?
	}
}
