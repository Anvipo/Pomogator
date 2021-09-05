//
//  UIView.SameAnchorConstraintsWithInfo.swift
//  Pomogator
//
//  Created by Anvipo on 03.01.2023.
//

import UIKit

// swiftlint:disable:next file_types_order
extension UIView {
	struct SameAnchorConstraintsWithInfo {
		let leading: NSLayoutConstraint?

		let top: NSLayoutConstraint?

		let trailing: NSLayoutConstraint?

		let bottom: NSLayoutConstraint?

		let centerY: NSLayoutConstraint?

		let centerX: NSLayoutConstraint?

		let width: NSLayoutConstraint?

		let height: NSLayoutConstraint?

		init(
			leading: NSLayoutConstraint? = nil,
			top: NSLayoutConstraint? = nil,
			trailing: NSLayoutConstraint? = nil,
			bottom: NSLayoutConstraint? = nil,
			centerY: NSLayoutConstraint? = nil,
			centerX: NSLayoutConstraint? = nil,
			width: NSLayoutConstraint? = nil,
			height: NSLayoutConstraint? = nil
		) {
			self.leading = leading
			self.top = top
			self.trailing = trailing
			self.bottom = bottom
			self.centerY = centerY
			self.centerX = centerX
			self.width = width
			self.height = height
		}
	}
}

extension UIView.SameAnchorConstraintsWithInfo {
	var onlyConstraints: [NSLayoutConstraint] {
		[leading, top, trailing, bottom, centerY, centerX, width, height].compactMap { $0 }
	}
}
