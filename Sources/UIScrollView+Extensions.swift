//
//  UIScrollView+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 30.08.2021.
//

import UIKit

extension UIScrollView {
	var realContentOffsetY: CGFloat {
		contentOffset.y + contentInset.top + safeAreaInsets.top
	}

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

		let centeringInset = (visibleContentHeight - contentHeight) / 2
		let topInset = max(centeringInset, 0)

		var newContentInset = contentInset
		newContentInset.top = topInset
		contentInset = newContentInset
	}
}

extension UIScrollView {
	var maxOffsetY: CGFloat {
		contentSize.height - bounds.height + adjustedContentInset.bottom
	}

	var maxOffsetX: CGFloat {
		contentSize.width - bounds.width + contentInset.right
	}

	func isScrolledToTop(screen: UIScreen) -> Bool {
		// не учитывается погрешность плавающей точки
		abs(contentOffset.y + adjustedContentInset.top) < (1 / screen.scale)
	}

	func isScrolledToBottom(screen: UIScreen) -> Bool {
		// не учитывается погрешность плавающей точки
		abs(contentOffset.y - maxOffsetY) < (1 / screen.scale)
	}

	func scrollToTop(animated: Bool = false) {
		applyOffset(-adjustedContentInset.top, for: .y, animated: animated)
	}

	func scrollToLeft(animated: Bool = false) {
		applyOffset(-contentInset.left, for: .x, animated: animated)
	}

	func scrollToRight(animated: Bool = false) {
		let offset = max(-contentInset.left, maxOffsetX)
		applyOffset(offset, for: .x, animated: animated)
	}

	/// Изменяет content offset так, чтобы верх контента было как можно выше на экране
	func scrollToContentTop(animated: Bool = false) {
		let y: CGFloat

		if frame.height < contentSize.height {
			y = 0
		} else {
			y = -(frame.height - contentSize.height)
		}
		applyOffset(y, for: .y, animated: animated)
	}

	func scrollToBottom(animated: Bool = false) {
		let offet = max(-adjustedContentInset.top, maxOffsetY)
		applyOffset(offet, for: .y, animated: animated)
	}

	func scrollToTopOf(of view: UIView, animated: Bool = false, inset: CGFloat = 0) {
		let newY = convert(view.bounds.origin, from: view).y - inset

		if newY > maxOffsetY {
			scrollToBottom(animated: animated)
		} else if newY <= 0 {
			scrollToTop(animated: animated)
		} else {
			applyOffset(newY, for: .y, animated: animated)
		}
	}

	func stopDecelerating() {
		setContentOffset(contentOffset, animated: false)
	}

	func applyOffset(_ point: CGFloat, for axis: ScrollAxis, animated: Bool = false) {
		let newOffset: CGPoint

		switch axis {
		case .x:
			newOffset = CGPoint(x: point, y: contentOffset.y)

		case .y:
			newOffset = CGPoint(x: contentOffset.x, y: point)
		}

		setContentOffset(newOffset, animated: animated)
	}

	/// Фокусируется на вьюшке, если она вылезает за видимые пределы
	func scroll(to view: UIView, animated: Bool = false) {
		let convertedRect = convert(view.frame, to: self)
		let visibleRect = CGRect(origin: contentOffset, size: visibleSize)

		var newOffset = contentOffset
		if convertedRect.minX < visibleRect.minX {
			newOffset.x = convertedRect.minX
		} else if convertedRect.maxX > visibleRect.maxX {
			newOffset.x = convertedRect.maxX - visibleRect.width
		}
		if convertedRect.minY < visibleRect.minY {
			newOffset.y = convertedRect.minY
		} else if convertedRect.maxY > visibleRect.maxY {
			newOffset.y = convertedRect.maxY - visibleRect.height
		}

		setContentOffset(newOffset, animated: animated)
	}
}
