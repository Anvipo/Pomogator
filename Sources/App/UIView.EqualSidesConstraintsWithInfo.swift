//
//  UIView.EqualSidesConstraintsWithInfo.swift
//  App
//
//  Created by Anvipo on 19.02.2023.
//

import UIKit

extension UIView {
	struct EqualSidesConstraintsWithInfo {
		private let ratioConstraint: NSLayoutConstraint
		let sideConstraint: NSLayoutConstraint

		init(
			ratioConstraint: NSLayoutConstraint,
			sideConstraint: NSLayoutConstraint
		) {
			self.ratioConstraint = ratioConstraint
			self.sideConstraint = sideConstraint
		}
	}
}

extension UIView.EqualSidesConstraintsWithInfo {
	var constraintsForActivate: [NSLayoutConstraint] {
		if sideConstraint.constant == 0 {
			return [ratioConstraint]
		}

		return [ratioConstraint, sideConstraint]
	}
}
