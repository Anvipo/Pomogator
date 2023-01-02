//
//  FluidPageControl.swift
//  Pomogator
//
//  Created by Anvipo on 06.01.2023.
//

import UIKit

final class FluidPageControl: BasePageControl {
	private let convenientHitAreaCalculator: ConvenientHitAreaCalculator
	private let selectionFeedbackGenerator: UISelectionFeedbackGenerator

	private var inactive = [Layer]()
	private var active = Layer()

	override var intrinsicContentSize: CGSize {
		sizeThatFits(.zero)
	}

	init(selectionFeedbackGenerator: UISelectionFeedbackGenerator) {
		self.selectionFeedbackGenerator = selectionFeedbackGenerator

		convenientHitAreaCalculator = ConvenientHitAreaCalculator()

		super.init(frame: .zero)

		convenientHitAreaCalculator.view = self
	}

	override func sizeThatFits(_ size: CGSize) -> CGSize {
		CGSize(
			width: CGFloat(inactive.count) * pageIndicatorDiameter + CGFloat(inactive.count - 1) * pageIndicatorPadding,
			height: pageIndicatorDiameter
		)
	}

	override final func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		convenientHitAreaCalculator.point(inside: point, with: event, superImplementation: super.point(inside:with:))
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		selectionFeedbackGenerator.prepare()
	}

	// TODO: поддержать touchesMoved

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)

		if touches.count > 1 {
			assertionFailure("?")
		}

		guard let touch = touches.first else {
			assertionFailure("?")
			return
		}

		let point = touch.location(in: self)

		guard let touchIndex = inactive.enumerated().first(where: { $0.element.hitTest(point) != nil })?.offset else {
			return
		}

		delegate?.didTouch(pager: self, index: touchIndex)
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let floatCount = CGFloat(inactive.count)
		let x = (bounds.size.width - pageIndicatorDiameter * floatCount - pageIndicatorPadding * (floatCount - 1)) * 0.5
		let y = (bounds.size.height - pageIndicatorDiameter) * 0.5
		var frame = CGRect(x: x, y: y, width: pageIndicatorDiameter, height: pageIndicatorDiameter)

		active.cornerRadius = pageIndicatorRadius
		active.backgroundColor = (currentPageIndicatorTintColor ?? tintColor)?.cgColor
		active.frame = frame

		if pageIndicatorBorderWidth > 0, let pageIndicatorBorderColor {
			active.borderWidth = pageIndicatorBorderWidth
			active.borderColor = pageIndicatorBorderColor.cgColor
		}

		for (index, layer) in inactive.enumerated() {
			layer.backgroundColor = pageIndicatorTintColor(position: index)
				.withAlphaComponent(inactivePageIndicatorsAlpha)
				.cgColor

			if pageIndicatorBorderWidth > 0, let pageIndicatorBorderColor {
				layer.borderWidth = pageIndicatorBorderWidth
				layer.borderColor = pageIndicatorBorderColor.cgColor
			}
			layer.cornerRadius = pageIndicatorRadius
			layer.frame = frame
			layer.extendedTapAreaSize = CGSize(
				width: frame.width + pageIndicatorPadding,
				height: frame.height + pageIndicatorPadding
			)
			frame.origin.x += pageIndicatorDiameter + pageIndicatorPadding
		}
		update(for: pageIndicatorProgress)
	}

	override func updateNumberOfPages(_ count: Int) {
		inactive.forEach { $0.removeFromSuperlayer() }
		inactive = []
		inactive = (0..<count).map { _ in
			let layer = Layer()
			self.layer.addSublayer(layer)
			return layer
		}
		layer.addSublayer(active)

		setNeedsLayout()
		invalidateIntrinsicContentSize()
	}

	override func update(for progress: Double) {
		guard progress >= 0 && progress <= Double(numberOfPages - 1),
			let firstFrame = inactive.first?.frame,
			numberOfPages > 1
		else {
			return
		}

		let normalized = progress * Double(pageIndicatorDiameter + pageIndicatorPadding)
		let distance = abs(progress.rounded(.toNearestOrAwayFromZero) - progress)
		let mult = 1 + distance * 2

		var frame = active.frame

		frame.origin.x = CGFloat(normalized) + firstFrame.origin.x
		frame.size.width = frame.height * CGFloat(mult)
		frame.size.height = pageIndicatorDiameter

		active.frame = frame
	}

	override func didTouch(gesture: UITapGestureRecognizer) {
		selectionFeedbackGenerator.prepare()

		let point = gesture.location(ofTouch: 0, in: self)

		guard let touchIndex = inactive.enumerated().first(where: { $0.element.hitTest(point) != nil })?.offset else {
			return
		}

		delegate?.didTouch(pager: self, index: touchIndex)
	}
}

private extension FluidPageControl {
	var pageIndicatorDiameter: CGFloat {
		pageIndicatorRadius * 2
	}
}
