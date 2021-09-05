//
//  UIViewPropertyAnimator+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 12.01.2023.
//

import UIKit

extension UIViewPropertyAnimator {
	convenience init(
		keyboardNotification: KeyboardNotification,
		animations: @escaping () -> Void
	) {
		self.init(
			duration: keyboardNotification.animationDuration,
			curve: keyboardNotification.animationCurve,
			animations: animations
		)
	}
}
