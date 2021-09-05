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
	}
}

extension UIView.SameAnchorConstraintsWithInfo {
	var onlyConstraints: [NSLayoutConstraint] {
		[leading, top, trailing, bottom, centerY, centerX, width, height].compactMap { $0 }
	}
}
