//
//  PoedatorYourMealTimeListVC.EmptyView.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

// swiftlint:disable:next file_types_order
extension PoedatorYourMealTimeListVC {
	final class EmptyView: UIView {
		private let labelsStackView: UIStackView
		private let firstLabel: UILabel
		private let secondLabel: UILabel

		override init(frame: CGRect) {
			firstLabel = UILabel()
			secondLabel = UILabel()
			labelsStackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel])

			super.init(frame: .zero)

			setupUI()
		}

		@available(*, unavailable)
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}

private extension PoedatorYourMealTimeListVC.EmptyView {
	func setupUI() {
		firstLabel.font = Font.headline.uiFont
		firstLabel.numberOfLines = 0
		firstLabel.text = String(localized: "No calculated meal times")
		firstLabel.textAlignment = .center
		firstLabel.textColor = Color.label.uiColor

		secondLabel.font = Font.subheadline.uiFont
		secondLabel.numberOfLines = 0
		secondLabel.text = String(localized: "Shake to go to meal times calculator screen")
		secondLabel.textAlignment = .center
		secondLabel.textColor = Color.label.uiColor

		labelsStackView.axis = .vertical
		labelsStackView.spacing = 16

		addSubviewForConstraintsUse(labelsStackView)
		NSLayoutConstraint.activate(labelsStackView.makeSameAnchorConstraints(to: self, info: .edgesEqual()))
	}
}
