//
//  Sequence+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 28.08.2022.
//

import Foundation

extension Sequence {
	func asyncMap<T>(
		_ transform: @Sendable (Element) async throws -> T
	) async rethrows -> [T] {
		var values = [T]()

		for element in self {
			try await values.append(transform(element))
		}

		return values
	}
}
