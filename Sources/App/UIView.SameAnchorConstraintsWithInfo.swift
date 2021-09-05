//
//  UIView.SameAnchorConstraintsWithInfo.swift
//  App
//
//  Created by Anvipo on 03.01.2023.
//

import UIKit

extension UIView {
	struct SameAnchorConstraintsWithInfo {
		var leading: NSLayoutConstraint?

		var top: NSLayoutConstraint?

		var trailing: NSLayoutConstraint?

		var bottom: NSLayoutConstraint?

		var centerY: NSLayoutConstraint?

		var centerX: NSLayoutConstraint?

		var width: NSLayoutConstraint?

		var height: NSLayoutConstraint?

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
