//
//  UIScrollView+Extensions.swift
//  App
//
//  Created by Anvipo on 30.08.2021.
//

import UIKit

extension UIScrollView {
	func visibleSizeWithSafeArea(additionalSafeAreaInsets: UIEdgeInsets = .zero) -> CGSize {
		CGSize(
			width: visibleSize.width - additionalSafeAreaInsets.horizontal,
			height: visibleSize.height - additionalSafeAreaInsets.vertical
		)
	}

	func allContentFits(additionalSafeAreaInsets: UIEdgeInsets = .zero) -> Bool {
		setNeedsLayoutAndLayoutIfNeeded()

		return visibleSizeWithSafeArea(additionalSafeAreaInsets: additionalSafeAreaInsets).width >= contentSize.width &&
			   visibleSizeWithSafeArea(additionalSafeAreaInsets: additionalSafeAreaInsets).height >= contentSize.height
	}

	func centerContentVerticallyIfNeeded(additionalSafeAreaInsets: UIEdgeInsets = .zero) {
		setNeedsLayoutAndLayoutIfNeeded(checkVCVisibility: false)

		// сбрасываем отступы, т.к. устройство могут повернуть и контент уже начнёт влезать
		contentInset = additionalSafeAreaInsets
		verticalScrollIndicatorInsets = additionalSafeAreaInsets

		guard allContentFits(additionalSafeAreaInsets: additionalSafeAreaInsets) else {
			return
		}

		let visibleContentHeight = visibleSizeWithSafeArea(additionalSafeAreaInsets: additionalSafeAreaInsets).height
		let contentHeight = contentSize.height

		let topInset = (visibleContentHeight - contentHeight) / 2
		assert(topInset >= 0)

		var resultInsets = additionalSafeAreaInsets
		resultInsets.top += topInset

		contentInset = resultInsets
		verticalScrollIndicatorInsets = resultInsets
	}
}
