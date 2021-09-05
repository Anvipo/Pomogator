//
//  BasePresenter.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

@MainActor
class BasePresenter {
	private weak var baseCoordinator: BaseCoordinator?
	final var tasks: [AnyTask]

	init(
		baseCoordinator: BaseCoordinator?
	) {
		self.baseCoordinator = baseCoordinator

		tasks = []
	}

	func baseViewDidAppear() {
		prepareDidChangeScreenFeedbackGenerator()
	}

	func didTapBackButton() {
		prepareDidChangeScreenFeedbackGenerator()
		baseCoordinator?.didChangeScreenFeedbackGenerator.impactOccurred()
	}
}

extension BasePresenter {
	func prepareDidChangeScreenFeedbackGenerator() {
		guard let baseCoordinator else {
			assertionFailure("?")
			return
		}

		baseCoordinator.didChangeScreenFeedbackGenerator.prepare()
	}
}

extension BasePresenter: BaseViewOutput {}
