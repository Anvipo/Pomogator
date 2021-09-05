//
//  Lazy.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

// swiftlint:disable:next file_types_order
private extension Lazy {
	enum State {
		case uninitialized(() -> T)
		case initialized(T)
	}
}

/// Контейнер для ленивой инициализации значения.
final class Lazy<T> {
	private var state: State

	init(_ factory: @autoclosure @escaping () -> T) {
		state = .uninitialized(factory)
	}
}

extension Lazy {
	var wrappedValue: T {
		switch state {
		case .uninitialized(let factory):
			let instance = factory()
			state = .initialized(instance)
			return instance

		case .initialized(let instance):
			return instance
		}
	}
}
