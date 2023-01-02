//
//  BasePageControl.swift
//  Pomogator
//
//  Created by Anvipo on 05.01.2023.
//

import UIKit

class BasePageControl: UIControl {
	private var displayLink: CADisplayLink?
	private var tapEvent: UITapGestureRecognizer?
	private var moveToProgress: Double?

	weak var delegate: BasePageControlDelegate?

	var numberOfPages: Int = 0 {
		didSet {
			populateTintColors()
			updateNumberOfPages(numberOfPages)
			isHidden = hidesForSinglePage && numberOfPages <= 1
		}
	}

	var pageIndicatorProgress: Double = 0 {
		didSet {
			update(for: pageIndicatorProgress)
		}
	}

	var pageIndicatorPadding: CGFloat = 5 {
		didSet {
			setNeedsLayout()
			update(for: pageIndicatorProgress)
		}
	}

	var pageIndicatorRadius: CGFloat = 10 {
		didSet {
			setNeedsLayout()
			update(for: pageIndicatorProgress)
		}
	}

	var inactivePageIndicatorsAlpha: CGFloat = 0.4 {
		didSet {
			setNeedsLayout()
			update(for: pageIndicatorProgress)
		}
	}

	var hidesForSinglePage = true {
		didSet {
			setNeedsLayout()
		}
	}

	var pageIndicatorBorderWidth: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}

	var pageIndicatorBorderColor: UIColor? {
		didSet {
			setNeedsLayout()
		}
	}

	var pageIndicatorTintColor: UIColor? {
		didSet {
			setNeedsLayout()
		}
	}

	var currentPageIndicatorTintColor: UIColor? {
		didSet {
			setNeedsLayout()
		}
	}

	var tintColors: [UIColor] = [] {
		didSet {
			guard tintColors.count == numberOfPages else {
				fatalError("The number of tint colors needs to be the same as the number of page")
			}

			setNeedsLayout()
		}
	}

	var enableTouchEvents = true {
		didSet {
			if enableTouchEvents {
				enableTouch()
			} else {
				disableTouch()
			}
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupDisplayLink()
		if enableTouchEvents {
			enableTouch()
		} else {
			disableTouch()
		}
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// swiftlint:disable unavailable_function
	func updateNumberOfPages(_ count: Int) {
		fatalError("Should be implemented in child class")
	}

	func update(for pageIndicatorProgress: Double) {
		fatalError("Should be implemented in child class")
	}

	@objc
	func didTouch(gesture: UITapGestureRecognizer) {
		// Should be implemented in child class
	}
	// swiftlint:enable unavailable_function

	deinit {
		displayLink?.remove(from: .current, forMode: .default)
		displayLink?.invalidate()
	}
}

extension BasePageControl {
	var currentPage: Int {
		get {
			Int(pageIndicatorProgress)
		}
		set {
			pageIndicatorProgress = CGFloat(newValue)
		}
	}

	func pageIndicatorTintColor(position: Int) -> UIColor {
		if tintColors.count < numberOfPages {
			return pageIndicatorTintColor ?? .clear
		} else {
			return tintColors[position]
		}
	}
}

private extension BasePageControl {
	func populateTintColors() {
		guard !tintColors.isEmpty else {
			return
		}

		if tintColors.count > numberOfPages {
			tintColors = Array(tintColors.prefix(numberOfPages))
		} else if tintColors.count < numberOfPages {
			tintColors.append(
				contentsOf: Array(
					repeating: pageIndicatorTintColor ?? .clear,
					count: numberOfPages - tintColors.count
				)
			)
		}
	}

	func enableTouch() {
		if tapEvent == nil {
			setupTouchEvent()
		}
	}

	func disableTouch() {
		if let tapEvent {
			removeGestureRecognizer(tapEvent)
			self.tapEvent = nil
		}
	}

	func setupTouchEvent() {
		tapEvent = UITapGestureRecognizer(target: self, action: #selector(didTouch(gesture:)))
		// swiftlint:disable:next force_unwrapping
		addGestureRecognizer(tapEvent!)
	}

	func setupDisplayLink() {
		displayLink = CADisplayLink(target: WeakProxy(self), selector: #selector(updateFrame))
		displayLink?.add(to: .current, forMode: .default)
	}

	@objc
	func updateFrame() {
		animate()
	}

	func animate() {
		guard let moveToProgress else {
			return
		}

		let a = abs(Float(moveToProgress))
		let b = abs(Float(pageIndicatorProgress))

		if a > b {
			pageIndicatorProgress += 0.1
		}
		if a < b {
			pageIndicatorProgress -= 0.1
		}

		if a == b {
			pageIndicatorProgress = moveToProgress
			self.moveToProgress = nil
		}

		if pageIndicatorProgress < 0 {
			pageIndicatorProgress = 0
			self.moveToProgress = nil
		}

		if pageIndicatorProgress > Double(numberOfPages - 1) {
			pageIndicatorProgress = Double(numberOfPages - 1)
			self.moveToProgress = nil
		}
	}
}
