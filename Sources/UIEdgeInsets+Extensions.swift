//
//  UIEdgeInsets+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 08.01.2023.
//

import UIKit

extension UIEdgeInsets {
	var inverted: Self {
		.init(top: -top, left: -left, bottom: -bottom, right: -right)
	}

	var vertical: CGFloat {
		top + bottom
	}

	var horizontal: CGFloat {
		left + right
	}
}

extension UIEdgeInsets: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(left, top, right, bottom)
	}
}
