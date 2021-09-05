//
//  PoedatorSavedMealTimeScheduleVC.EmptyView.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

extension PoedatorSavedMealTimeScheduleVC {
	final class EmptyView: BaseView {
		private let labelsStackView: UIStackView
		private let firstLabel: UILabel
		private let secondLabel: UILabel

		override init() {
			firstLabel = UILabel()
			secondLabel = UILabel()
			labelsStackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel])

			super.init()

			setUpConstraints()
			setUpUI()
		}
	}
}

extension PoedatorSavedMealTimeScheduleVC.EmptyView {
	func viewDidLayoutSubviews(isSplitViewMode: Bool) {
		guard secondLabel.isHidden != isSplitViewMode else { return }

		secondLabel.isHidden = isSplitViewMode
	}
}

private extension PoedatorSavedMealTimeScheduleVC.EmptyView {
	func setUpConstraints() {
		addSubviewForConstraintsUse(labelsStackView)
		NSLayoutConstraint.activate(labelsStackView.makeEdgeConstraintsEqualToSuperview())
	}

	func setUpUI() {
		firstLabel.adjustsFontForContentSizeCategory = true
		firstLabel.font = FontStyle.headline.font
		firstLabel.numberOfLines = 0
		firstLabel.text = String(localized: "No saved meal time schedule text")
		firstLabel.textAlignment = .center
		firstLabel.textColor = ColorStyle.label.color

		secondLabel.adjustsFontForContentSizeCategory = true
		secondLabel.font = FontStyle.subheadline.font
		secondLabel.numberOfLines = 0
		secondLabel.text = String(localized: "No saved meal time schedule description")
		secondLabel.accessibilityLabel = String(localized: "No saved meal time schedule accessibility description")
		secondLabel.textAlignment = .center
		secondLabel.textColor = ColorStyle.label.color

		labelsStackView.axis = .vertical
		labelsStackView.spacing = 16
		labelsStackView.alignment = .center
		labelsStackView.distribution = .equalCentering

		isAccessibilityElement = true
		accessibilityTraits = .staticText
		accessibilityLabel = firstLabel.text
		accessibilityValue = secondLabel.accessibilityLabel
	}
}
