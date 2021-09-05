//
//  Weak.swift
//  Pomogator
//
//  Created by Anvipo on 05.01.2023.
//

final class Weak<Element: AnyObject> {
	private(set) weak var value: Element?
	private let objectIdentifier: ObjectIdentifier

	init(_ value: Element) {
		self.value = value
		self.objectIdentifier = ObjectIdentifier(value)
	}
}

extension Weak: Equatable {
	static func == (lhs: Weak<Element>, rhs: Weak<Element>) -> Bool {
		lhs.hashValue == rhs.hashValue
	}
}

extension Weak: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(objectIdentifier)
	}
}
