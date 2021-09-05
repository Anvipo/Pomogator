//
//  UIView.ConstraintsMakeInfo.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

extension UIView {
	struct ConstraintsMakeInfo {
		let leading: ConstraintMakeInfo?

		let top: ConstraintMakeInfo?

		let trailing: ConstraintMakeInfo?

		let bottom: ConstraintMakeInfo?

		let centerY: ConstraintMakeInfo?

		let centerX: ConstraintMakeInfo?

		let width: ConstraintMakeInfo?

		let height: ConstraintMakeInfo?

		init(
			leading: ConstraintMakeInfo? = nil,
			top: ConstraintMakeInfo? = nil,
			trailing: ConstraintMakeInfo? = nil,
			bottom: ConstraintMakeInfo? = nil,
			centerY: ConstraintMakeInfo? = nil,
			centerX: ConstraintMakeInfo? = nil,
			width: ConstraintMakeInfo? = nil,
			height: ConstraintMakeInfo? = nil
		) {
			self.leading = leading
			self.top = top
			self.trailing = trailing?.apply { $0.constant = -$0.constant }
			self.bottom = bottom?.apply { $0.constant = -$0.constant }

			self.centerY = centerY
			self.centerX = centerX

			self.width = width
			self.height = height
		}
	}
}

extension UIView.ConstraintsMakeInfo {
	static func equal(
		leading: CGFloat? = nil,
		top: CGFloat? = nil,
		trailing: CGFloat? = nil,
		bottom: CGFloat? = nil,
		centerY: CGFloat? = nil,
		centerX: CGFloat? = nil,
		width: CGFloat? = nil,
		height: CGFloat? = nil
	) -> Self {
		Self(
			leading: leading.flatMap { .equal(constant: $0) },
			top: top.flatMap { .equal(constant: $0) },
			trailing: trailing.flatMap { .equal(constant: $0) },
			bottom: bottom.flatMap { .equal(constant: $0) },
			centerY: centerY.flatMap { .equal(constant: $0) },
			centerX: centerX.flatMap { .equal(constant: $0) },
			width: width.flatMap { .equal(constant: $0) },
			height: height.flatMap { .equal(constant: $0) }
		)
	}
}
