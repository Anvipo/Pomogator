//
//  SplashScreenVC.swift
//  Pomogator
//
//  Created by Anvipo on 02.01.2023.
//

import Lottie
import UIKit

final class SplashScreenVC: BaseVC {
	private let completion: () -> Void

	private lazy var animationView = LottieAnimationView(animation: .splashScreen)

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		.portrait
	}

	init(completion: @escaping () -> Void) {
		self.completion = completion

		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		animationView.play { [weak self] _ in
			self?.completion()
		}
	}
}

private extension SplashScreenVC {
	func setupUI() {
		view.addSubviewForConstraintsUse(animationView)

		NSLayoutConstraint.activate(animationView.makeSameAnchorConstraints(to: view, info: .edgesEqual()))
	}
}
