//
//  UIScrollView+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 30.08.2021.
//

import UIKit

extension UIScrollView {
	var visibleSizeWithSafeArea: CGSize {
		CGSize(
			width: visibleSize.width - safeAreaInsets.horizontal,
			height: visibleSize.height - safeAreaInsets.vertical
		)
	}

	var allContentFits: Bool {
		visibleSizeWithSafeArea.width >= contentSize.width &&
		visibleSizeWithSafeArea.height >= contentSize.height
	}

	func centerContentVerticallyIfNeeded() {
		layoutViewIfNeededOrSetNeedsLayout()

		guard allContentFits else {
			contentInset.top = 0
			return
		}

		let visibleContentHeight = visibleSizeWithSafeArea.height
		let contentHeight = contentSize.height

		let centeringInset = (visibleContentHeight - contentHeight - contentInset.bottom) / 2
		let topInset = max(centeringInset, 0)

		var newContentInset = contentInset
		newContentInset.top = topInset
		contentInset = newContentInset
	}
}
