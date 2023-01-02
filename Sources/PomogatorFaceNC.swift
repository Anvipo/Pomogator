//
//  PomogatorFaceNC.swift
//  Pomogator
//
//  Created by Anvipo on 14.01.2023.
//

import UIKit

final class PomogatorFaceNC: UINavigationController, UINavigationControllerDelegate {
	init(rootViewController: PomogatorFaceVC) {
		super.init(rootViewController: rootViewController)
		modalPresentationStyle = .fullScreen
		delegate = self
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func navigationControllerSupportedInterfaceOrientations(
		_ navigationController: UINavigationController
	) -> UIInterfaceOrientationMask {
		.portrait
	}

	func navigationControllerPreferredInterfaceOrientationForPresentation(
		_ navigationController: UINavigationController
	) -> UIInterfaceOrientation {
		.portrait
	}
}
