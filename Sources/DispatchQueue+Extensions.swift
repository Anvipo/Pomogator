//
//  DispatchQueue+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 10.01.2023.
//

import Foundation

extension DispatchQueue {
	static func asyncOnMain(execute work: @escaping () -> Void) {
		if self === Self.main, Thread.isMainThread {
			work()
		} else {
			main.async(execute: work)
		}
	}

	@discardableResult
	static func syncOnMain<Result>(execute work: @escaping () throws -> Result) rethrows -> Result {
		if self === Self.main, Thread.isMainThread {
			return try work()
		} else {
			return try main.sync(execute: work)
		}
	}
}
