//
//  BasePresenter.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

class BasePresenter {
	private weak var baseCoordinator: BaseCoordinatorProtocol?
	var tasks: [AnyTask]

	init(
		baseCoordinator: BaseCoordinatorProtocol?
	) {
		self.baseCoordinator = baseCoordinator

		tasks = []
	}

	func baseViewDidAppear() {
		baseCoordinator?.didChangeScreenFeedbackGenerator.prepare()
	}

	func didTapBackButton() {
		baseCoordinator?.didChangeScreenFeedbackGenerator.prepare()
		baseCoordinator?.didChangeScreenFeedbackGenerator.impactOccurred()
	}

	deinit {
		tasks = []
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
