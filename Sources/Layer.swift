//
//  Layer.swift
//  Pomogator
//
//  Created by Anvipo on 05.01.2023.
//

import QuartzCore

class Layer: CALayer {
	final var extendedTapAreaSize: CGSize?

	override init() {
		super.init()

		actions = [
			"bounds": NSNull(),
			"frame": NSNull(),
			"position": NSNull()
		]
	}

	override init(layer: Any) {
		super.init(layer: layer)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func hitTest(_ point: CGPoint) -> CALayer? {
		guard let extendedTapAreaSize else {
			return super.hitTest(point)
		}

		let originalRect = frame

		let extendedXOrigin: CGFloat
		let extendedWidth: CGFloat
		if originalRect.width >= extendedTapAreaSize.width {
			extendedXOrigin = originalRect.origin.x
			extendedWidth = originalRect.width
		} else {
			extendedXOrigin = originalRect.origin.x - ((extendedTapAreaSize.width - originalRect.width) / 2)
			extendedWidth = extendedTapAreaSize.width
		}

		let extendedYOrigin: CGFloat
		let extendedHeight: CGFloat
		if originalRect.height >= extendedTapAreaSize.height {
			extendedYOrigin = originalRect.origin.y
			extendedHeight = originalRect.height
		} else {
			extendedYOrigin = originalRect.origin.y - ((extendedTapAreaSize.height - originalRect.height) / 2)
			extendedHeight = extendedTapAreaSize.height
		}

		let extendedRect = CGRect(
			x: extendedXOrigin,
			y: extendedYOrigin,
			width: extendedWidth,
			height: extendedHeight
		)

		if extendedRect.contains(point) {
			return self
		} else {
			return nil
		}
	}
}
