//
//  PoedatorSplitViewController.swift
//  App
//
//  Created by Anvipo on 23.04.2023.
//

import UIKit

final class PoedatorSplitViewController: BaseSplitViewController {
	override init() {
		super.init()

		// чтобы в вертикальной ориентации тоже было разбиение на master и details
		preferredDisplayMode = .oneBesideSecondary
	}

	@available(*, unavailable)
	override func show(_ column: UISplitViewController.Column) {
		super.show(column)
	}

	@available(*, unavailable)
	override func hide(_ column: UISplitViewController.Column) {
		super.hide(column)
	}

	@available(*, unavailable)
	override func setViewController(_ vc: UIViewController?, for column: UISplitViewController.Column) {
		super.setViewController(vc, for: column)
	}

	@available(*, unavailable)
	override func viewController(for column: UISplitViewController.Column) -> UIViewController? {
		super.viewController(for: column)
	}
}
