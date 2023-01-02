//
//  LottieAnimationView+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 02.01.2023.
//

import Lottie

extension LottieAnimationView {
	convenience init(animation: Animation) {
		self.init(name: animation.name)
	}
}
