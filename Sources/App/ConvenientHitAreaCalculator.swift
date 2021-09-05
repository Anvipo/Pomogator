//
//  ConvenientHitAreaCalculator.swift
//  App
//
//  Created by Anvipo on 10.01.2023.
//

import UIKit

final class ConvenientHitAreaCalculator {
	typealias PointInsideSignature = (_ point: CGPoint, _ event: UIEvent?) -> Bool

	var convenientHitAreaConfiguration: ConvenientHitAreaConfiguration
	weak var view: UIView?

	init(
		convenientHitAreaConfiguration: ConvenientHitAreaConfiguration = .default,
		view: UIView? = nil
	) {
		self.convenientHitAreaConfiguration = convenientHitAreaConfiguration
		self.view = view
	}

	func point(inside point: CGPoint, with event: UIEvent?, superImplementation: PointInsideSignature) -> Bool {
		guard let view else {
			assertionFailure("?")
			return false
		}

		let convenientHitAreaWidth = convenientHitAreaConfiguration.convenientHitSize.width
		let convenientHitAreaHeight = convenientHitAreaConfiguration.convenientHitSize.height

		let viewBoundsWidth = view.bounds.width
		let viewBoundsHeight = view.bounds.height

		let isInconvenientWidth = viewBoundsWidth < convenientHitAreaWidth
		let isInconvenientHeight = viewBoundsHeight < convenientHitAreaHeight

		if !isInconvenientWidth && !isInconvenientHeight {
			return superImplementation(point, event)
		}

		var additionalInsets = UIEdgeInsets.zero

		if isInconvenientWidth {
			let additionalHorizontalInset = convenientHitAreaWidth - viewBoundsWidth
			let additionalSideInset = (additionalHorizontalInset / 2).rounded(.up)
			additionalInsets.left += additionalSideInset
			additionalInsets.right += additionalSideInset
		}

		if isInconvenientHeight {
			let additionalVerticalInset = convenientHitAreaHeight - viewBoundsHeight
			let additionalSideInset = (additionalVerticalInset / 2).rounded(.up)
			additionalInsets.top += additionalSideInset
			additionalInsets.bottom += additionalSideInset
		}

		let targetRect = view.bounds.inset(by: additionalInsets.inverted)
		return targetRect.contains(point)
	}
}
