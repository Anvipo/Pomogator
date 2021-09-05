//
//  AnyTask.swift
//  App
//
//  Created by Anvipo on 14.01.2023.
//

final class AnyTask: Sendable {
	private let isCancelledClosure: @Sendable () -> Bool

	let cancel: @Sendable () -> Void

	init<S, E>(_ task: Task<S, E>) {
		cancel = { task.cancel() }
		isCancelledClosure = { task.isCancelled }
	}

	deinit {
		if !isCancelled {
			cancel()
		}
	}
}

extension AnyTask {
	var isCancelled: Bool {
		isCancelledClosure()
	}
}

extension Array where Element == AnyTask {
	mutating func append<S, E>(_ task: Task<S, E>) {
		append(task.eraseToAnyTask())
	}
}

private extension Task {
	func eraseToAnyTask() -> AnyTask {
		AnyTask(self)
	}
}
