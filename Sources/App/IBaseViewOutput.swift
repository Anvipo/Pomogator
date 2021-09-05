//
//  IBaseViewOutput.swift
//  App
//
//  Created by Anvipo on 29.08.2021.
//

protocol IBaseViewOutput: AnyObject {
	func didTapNCBackButton()

	func willMoveFromParentVC()
	func didMoveFromParentVC()

	func didReceiveMemoryWarning()
}

extension IBaseViewOutput {
	func didTapNCBackButton() {
		assertionFailure("Реализуй этот метод")
	}

	// swiftlint:disable no_empty_block
	func willMoveFromParentVC() {}
	func didMoveFromParentVC() {}
	// swiftlint:enable no_empty_block

	func didReceiveMemoryWarning() {
		assertionFailure("Пришла пора реализовать этот метод для \(self)")
	}
}
