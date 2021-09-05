//
//  WeakArray.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

struct WeakArray<Element: AnyObject> {
	private var storage: [Weak<Element>]
}

extension WeakArray {
	var notNilValues: [Element] {
		storage.compactMap { $0.value }
	}
}

extension WeakArray: RandomAccessCollection {
	var startIndex: Int {
		storage.startIndex
	}

	var endIndex: Int {
		storage.endIndex
	}

	func index(after index: Int) -> Int {
		storage.index(after: index)
	}
}

extension WeakArray: MutableCollection {
	subscript(index: Int) -> Element? {
		get {
			storage[index].value
		}
		set {
			if let newValue {
				storage[index] = Weak(newValue)
			} else {
				storage.remove(at: index)
			}
		}
	}
}

extension WeakArray: RangeReplaceableCollection {
	init() {
		storage = []
	}

	init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
		storage = sequence.map(Weak.init)
	}

	mutating func replaceSubrange<C: Collection>(
		_ subrange: Range<Int>,
		with newElements: C
	) where C.Iterator.Element == Element? {
		let wrapperCollection = newElements.compactMap { $0 }.map(Weak.init)
		storage.replaceSubrange(subrange, with: wrapperCollection)
		compact()
	}
}

extension WeakArray: ExpressibleByArrayLiteral {
	init(arrayLiteral elements: Element...) {
		storage = elements.map(Weak.init)
	}
}

extension WeakArray: CustomReflectable {
	var customMirror: Mirror {
		storage.map { $0.value }.customMirror
	}
}

extension WeakArray: CustomStringConvertible {
	var description: String {
		storage.map { $0.value }.description
	}
}

extension WeakArray: CustomDebugStringConvertible {
	var debugDescription: String {
		storage.debugDescription
	}
}

// TODO: copy-on-write
// https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst#advice-use-copy-on-write-semantics-for-large-values
/*extension WeakArray {
	/// Ensure that this storage refers to a uniquely held buffer by copying
	/// elements if necessary.
	mutating func ensureUnique() {
		if !isKnownUniquelyReferenced(&self._storage) {
			self = _Node(copyingFrom: self)
		}
	}

	// Check CoW copying behavior
	do {
	  var set = OrderedSet<Int>(0 ..< 30)
	  let copy = set
	  expectNil(set.unordered.update(with: 30))
	  expectTrue(set.contains(30))
	  expectFalse(copy.contains(30))
	}
}
*/

private extension WeakArray {
	mutating func compact() {
		storage = storage.compactMap { $0 }
	}
}
