//
//  VychislyatorBodyMassIndexRestoreInfo.swift
//  Pomogator
//
//  Created by Anvipo on 26.01.2023.
//

import Foundation

struct VychislyatorBodyMassIndexRestoreInfo {
	let massInKg: Decimal?
	let heightInCm: Decimal?
}

extension VychislyatorBodyMassIndexRestoreInfo: IRestoreInfo {
	init(userActivity: NSUserActivity) {
		self.init(
			massInKg: userActivity.restoredMassInKg,
			heightInCm: userActivity.restoredHeightInCm
		)
	}

	func save(into userActivity: NSUserActivity) {
		userActivity.restoredMassInKg = massInKg
		userActivity.restoredHeightInCm = heightInCm
	}
}

private extension String {
	static var restoredMassInKgKey: Self {
		"vychislyator.bodyMassIndex.restoredMassInKg"
	}

	static var restoredHeightInCmKey: Self {
		"vychislyator.bodyMassIndex.restoredHeightInCm"
	}
}

private extension NSUserActivity {
	var restoredMassInKg: Decimal? {
		get {
			guard let userInfo,
				  let restoredMassInKgRawValue = userInfo[String.restoredMassInKgKey],
				  let restoredMassInKg = restoredMassInKgRawValue as? Decimal
			else {
				return nil
			}

			return restoredMassInKg
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredMassInKgKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredMassInKgKey: newValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}

	var restoredHeightInCm: Decimal? {
		get {
			guard let userInfo,
				  let restoredHeightInCmRawValue = userInfo[String.restoredHeightInCmKey],
				  let restoredHeightInCm = restoredHeightInCmRawValue as? Decimal
			else {
				return nil
			}

			return restoredHeightInCm
		}
		set {
			guard let newValue else {
				userInfo?.removeValue(forKey: String.restoredHeightInCmKey)
				return
			}

			let userInfoEntries: [AnyHashable: Any] = [
				String.restoredHeightInCmKey: newValue
			]
			addUserInfoEntries(from: userInfoEntries)
		}
	}
}
