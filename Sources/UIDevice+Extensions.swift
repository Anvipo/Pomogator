//
//  UIDevice+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 23.12.2022.
//

import UIKit

extension UIDevice {
	static var modelName: String {
		var systemInfo = utsname()
		uname(&systemInfo)

		let machineMirror = Mirror(reflecting: systemInfo.machine)

		return machineMirror.children.reduce(into: "") { identifier, element in
			if let value = element.value as? Int8,
			   value != 0 {
				identifier += String(UnicodeScalar(UInt8(value)))
			}
		}
	}

	var isPhone: Bool {
		userInterfaceIdiom == .phone
	}

	var isPad: Bool {
		userInterfaceIdiom == .pad
	}

	var isSimulator: Bool {
		#if targetEnvironment(simulator)
			return true
		#else
			return false
		#endif
	}

	func isPadOrLandscapePhone(screen: UIScreen) -> Bool {
		if isPad {
			return true
		}

		return screen.isInLandscapeOrientation
	}
}
