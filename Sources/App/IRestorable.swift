//
//  IRestorable.swift
//  App
//
//  Created by Anvipo on 25.01.2023.
//

import Foundation

protocol IRestorable: AnyObject {
	func saveUserActivityForRestore(to userActivity: NSUserActivity)

	func restore(from userActivity: NSUserActivity)
}
