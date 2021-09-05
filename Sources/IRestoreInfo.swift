//
//  IRestoreInfo.swift
//  Pomogator
//
//  Created by Anvipo on 25.01.2023.
//

import Foundation

protocol IRestoreInfo {
	init(userActivity: NSUserActivity)

	func save(into userActivity: NSUserActivity)
}
