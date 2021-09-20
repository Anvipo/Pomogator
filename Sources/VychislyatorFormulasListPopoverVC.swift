//
//  VychislyatorFormulasListPopoverVC.swift
//  Pomogator
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit

final class VychislyatorFormulasListPopoverVC: BaseVC {
	private static var insets: NSDirectionalEdgeInsets {
		.init(horizontalInset: .defaultHorizontalOffset, verticalInset: 0)
	}

	private let text: String

	private lazy var label = UILabel()

	override var preferredContentSize: CGSize {
		get {
			guard let presentingViewController else {
				assertionFailure("?")
				return super.preferredContentSize
			}

			let parentWidth = presentingViewController.view.bounds.width - Self.insets.horizontal

			return .init(
				width: parentWidth,
				height: label.actualContentHeight(availableWidth: parentWidth / 2)
			)
		}
		// swiftlint:disable:next unused_setter_value
		set {
			assertionFailure("?")
		}
	}

	init(
		sourceView: UIView,
		text: String
	) {
		self.text = text

		super.init()

		modalPresentationStyle = .popover

		guard let popoverPresentationController else {
			assertionFailure("?")
			return
		}

		popoverPresentationController.delegate = self

		popoverPresentationController.permittedArrowDirections = [.up, .down]
		popoverPresentationController.sourceItem = sourceView
		popoverPresentationController.backgroundColor = Color.brand.uiColor
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .clear

		label.numberOfLines = 0
		label.font = Font.body.uiFont
		label.text = text
		label.textAlignment = .center
		label.textColor = Color.labelOnBrand.uiColor

		view.addSubviewForConstraintsUse(label)
		NSLayoutConstraint.activate(
			label.makeSameAnchorConstraints(
				to: view.safeAreaLayoutGuide,
				info: .edgesEqual(insets: Self.insets)
			)
		)
	}
}

extension VychislyatorFormulasListPopoverVC: UIPopoverPresentationControllerDelegate {
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		.none
	}
}
