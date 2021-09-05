//
//  AnyTask.swift
//  Pomogator
//
//  Created by Anvipo on 14.01.2023.
//

final class AnyTask {
	private let cancel: () -> Void
	private let isCancelledClosure: () -> Bool

	init<S, E>(_ task: Task<S, E>) {
		cancel = task.cancel
		isCancelledClosure = { task.isCancelled }
	}

	deinit {
		if !isCancelled {
			cancel()
		}
	}
}

extension Array where Element == AnyTask {
	mutating func append<S, E>(_ task: Task<S, E>) {
		append(task.eraseToAnyTask())
	}
}

private extension AnyTask {
	var isCancelled: Bool {
		isCancelledClosure()
	}
}

private extension Task {
	func eraseToAnyTask() -> AnyTask {
		AnyTask(self)
	}
}
