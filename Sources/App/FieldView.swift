//
//  FieldView.swift
//  App
//
//  Created by Anvipo on 26.09.2021.
//

import UIKit

class FieldView<ContentView: UIView, ID: IDType>: BaseView {
	private let commonStackView: UIStackView
	private let iconImageView: UIImageView
	private let titleLabel: UILabel
	private let contentStackView: UIStackView
	private let accessoryButton: Button

	private var item: FieldItem<ID>!
	private var iconImageViewSideConstraint: NSLayoutConstraint!

	let contentView: ContentView

	var accessibilityContentText: String {
		let accessibilityLabel = contentView.accessibilityLabel
		let accessibilityValue = contentView.accessibilityValue

		return [accessibilityLabel, accessibilityValue].compactMap { $0 }.joined(separator: ",")
	}

	override init() {
		iconImageView = UIImageView()
		titleLabel = UILabel()
		contentView = ContentView()
		contentStackView = UIStackView(arrangedSubviews: [titleLabel, contentView])
		accessoryButton = Button(fullConfiguration: nil)

		commonStackView = UIStackView(arrangedSubviews: [iconImageView, contentStackView, accessoryButton])

		super.init()

		setUpConstraints()
		setUpUI()
	}

	override func traitPreferredContentSizeCategoryDidChange(_: UITraitCollection) {
		setUpUIBasedOnTraitCollection()
	}

	override func handle(
		presses: Set<UIPress>,
		event: UIPressesEvent?,
		superImplementation: HandlePressesClosure
	) {
		guard presses.count == 1,
			  let press = presses.first
		else {
			assertionFailure("?")
			superImplementation(presses, event)
			return
		}

		guard let pressedKey = press.key else {
			superImplementation(presses, event)
			return
		}

		switch pressedKey.keyCode {
		case .keyboardTab:
			if press.phase == .ended {
				if contentView.isFirstResponder {
					item.respondersFacade.nextResponderProvider?()?.becomeFirstResponder()
				} else {
					contentView.becomeFirstResponder()
				}
			}

		case .keyboardReturnOrEnter:
			if press.phase == .ended && contentView.isFirstResponder {
				contentView.resignFirstResponder()
			} else {
				superImplementation(presses, event)
			}

		case .keyboardI:
			if press.phase == .ended && contentView.isFirstResponder {
				accessoryButton.fullConfiguration?.onTap(accessoryButton)
			}

		default:
			superImplementation(presses, event)
		}
	}
}

extension FieldView {
	func configure(with item: FieldItem<ID>) {
		self.item = item

		backgroundColor = item.backgroundColorStyle.color
		tintColor = item.tintColorStyle.color

		iconImageView.tintColor = item.iconTintColorStyle?.color
		iconImageView.adjustsImageSizeForAccessibilityContentSizeCategory = item.iconAdjustsImageSizeForAccessibilityContentSizeCategory

		titleLabel.adjustsFontForContentSizeCategory = item.titleAdjustsFontForContentSizeCategory
		titleLabel.font = item.titleFontStyle.font
		titleLabel.numberOfLines = item.titleNumberOfLines
		titleLabel.textColor = item.titleColorStyle.color
		titleLabel.tintColor = item.titleTintColorStyle.color

		accessoryButton.isHidden = item.accessoryButtonFullConfiguration == nil
		if var accessoryButtonFullConfiguration = item.accessoryButtonFullConfiguration {
			accessoryButtonFullConfiguration.onTap = { [weak self] accessoryButton in
				guard let self else {
					return
				}

				self.item.delegate?.fieldItem(self.item, didTapAccessoryButton: accessoryButton)
			}
			accessoryButton.configure(with: accessoryButtonFullConfiguration)
		}

		item.respondersFacade.responderProvider = { [weak self] in
			guard let self else {
				assertionFailure("?")
				return nil
			}

			return contentView
		}
		item.accessibilityInfoProvider.accessibilityTextProvider = { [weak self] in
			self?.accessibilityContentText ?? ""
		}

		setUpStyle()
		setUpUIBasedOnTraitCollection()

		commonStackView.directionalLayoutMargins = item.contentInsets
	}
}

extension FieldView {
	func set(icon: Image) {
		var icon = icon.uiImage
		if let iconTintColorStyle = item.iconTintColorStyle {
			icon = icon.withTintColor(iconTintColorStyle.color)
		}
		iconImageView.image = icon
	}

	func set(title: String) {
		titleLabel.text = title
		contentView.accessibilityLabel = title
	}

	func setUpStyle() {
		animate(duration: defaultAnimationDuration) { fieldView in
			if fieldView.contentView.isFirstResponder {
				fieldView.titleLabel.textColor = ColorStyle.brand.color
				fieldView.backgroundColor = ColorStyle.brand.color.withAlphaComponent(0.1)
			} else {
				fieldView.titleLabel.textColor = fieldView.item.titleColorStyle.color
				fieldView.backgroundColor = nil
			}
		}
	}
}

private extension FieldView {
	func setUpConstraints() {
		let iconImageViewConstraintsInfo = iconImageView.makeEqualSidesConstraintsWithInfo(side: nil)

		iconImageViewSideConstraint = iconImageViewConstraintsInfo.sideConstraint

		addSubviewForConstraintsUse(commonStackView)

		let constraintsForActivate = iconImageViewConstraintsInfo.constraintsForActivate +
		accessoryButton.makeEqualSidesConstraintsWithInfo(side: nil).constraintsForActivate +
		commonStackView.makeEdgeConstraintsEqualToSuperview()

		NSLayoutConstraint.activate(constraintsForActivate)
	}

	func setUpUI() {
		commonStackView.spacing = 16
		commonStackView.isLayoutMarginsRelativeArrangement = true

		iconImageView.setContentHuggingPriority(.required, for: .horizontal)
		iconImageView.setContentHuggingPriority(.required, for: .vertical)

		contentView.setContentHuggingPriority(.required, for: .horizontal)
		contentView.setContentHuggingPriority(.required, for: .vertical)

		accessoryButton.setContentHuggingPriority(.required, for: .horizontal)
		accessoryButton.setContentHuggingPriority(.required, for: .vertical)

		contentStackView.axis = .vertical
		contentStackView.spacing = 4
		contentStackView.alignment = .leading

		iconImageView.isAccessibilityElement = false
		titleLabel.isAccessibilityElement = false

		accessibilityElements = [contentView, accessoryButton]

		registerForTraitPreferredContentSizeCategoryChanges()
	}

	func setUpUIBasedOnTraitCollection() {
		let currentIsAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory

		commonStackView.axis = currentIsAccessibilityCategory ? .vertical : .horizontal
		commonStackView.alignment = currentIsAccessibilityCategory ? .leading : .center

		if item.iconAdjustsImageSizeForAccessibilityContentSizeCategory {
			iconImageViewSideConstraint.constant = item.titleFontStyle.fontMetrics.scaledValue(for: 35)

			if !iconImageViewSideConstraint.isActive {
				iconImageViewSideConstraint.isActive = true
			}
		}
	}
}
