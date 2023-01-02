//
//  OnboardingLastStepVC.swift
//  Pomogator
//
//  Created by Anvipo on 07.01.2023.
//

import UIKit

// swiftlint:disable:next file_types_order
private extension CGFloat {
	static var inset: Self {
		32
	}
}

final class OnboardingLastStepVC: BaseVC {
	private let itemViews: [UIView]

	private lazy var scrollView = UIScrollView()

	init(models: [OnboardingLastStepItemView.Model]) {
		itemViews = models.map { OnboardingLastStepItemView(model: $0, insets: .init(horizontalInset: .inset)) }

		super.init()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		scrollView.centerContentVerticallyIfNeeded()
	}
}

private extension OnboardingLastStepVC {
	func setupUI() {
		view.backgroundColor = .clear

		let stackView = UIStackView(arrangedSubviews: itemViews)
		stackView.axis = .vertical
		stackView.spacing = 64

		scrollView.addSubviewForConstraintsUse(stackView)

		view.addSubviewForConstraintsUse(scrollView)

		NSLayoutConstraint.activate(
			stackView.makeSameAnchorConstraints(
				to: scrollView,
				info: .equal(leading: 0, top: 0, trailing: 0, bottom: 0, width: 0)
			) +
			scrollView.makeSameAnchorConstraints(
				to: view.safeAreaLayoutGuide,
				info: .edgesEqual(insets: .init(horizontalInset: 0, verticalInset: .inset))
			)
		)
	}
}
