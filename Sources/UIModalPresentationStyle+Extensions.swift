//
//  UIModalPresentationStyle+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 10.01.2023.
//

import UIKit

extension UIModalPresentationStyle {
	static func classicModalPresentationStyle(device: UIDevice) -> Self {
		device.isPad ? .formSheet : .fullScreen
	}
}
