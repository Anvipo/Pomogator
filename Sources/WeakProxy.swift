//
//  WeakProxy.swift
//  Pomogator
//
//  Created by Anvipo on 06.01.2023.
//

import Foundation

final class WeakProxy: NSObject {
	weak var target: NSObjectProtocol?

	init(_ target: NSObjectProtocol) {
		self.target = target

		super.init()
	}

	// swiftlint:disable:next implicitly_unwrapped_optional
	override func responds(to aSelector: Selector!) -> Bool {
		guard let target else {
			return super.responds(to: aSelector)
		}

		return target.responds(to: aSelector)
	}

	// swiftlint:disable:next implicitly_unwrapped_optional
	override func forwardingTarget(for aSelector: Selector!) -> Any? {
		target
	}
}
