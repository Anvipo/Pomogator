//
//  MainVC.swift
//  App
//
//  Created by Anvipo on 14.01.2023.
//

import UIKit

final class MainVC: BaseTableVC<
	MainSectionIdentifier,
	MainItemIdentifier
> {
	private let presenter: MainPresenter

	init(presenter: MainPresenter) {
		self.presenter = presenter

		super.init(output: presenter)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpConstraints()
		setUpUI()
		presenter.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter.viewWillAppear()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.centerContentVerticallyIfNeeded()
	}
}

private extension MainVC {
	func setUpConstraints() {
		view.addSubviewsForConstraintsUse([tableView])
		NSLayoutConstraint.activate(tableView.makeEdgeConstraintsEqualToSuperviewSafeArea())
	}

	func setUpUI() {
		navigationItem.title = String(localized: "Main screen title")

		observeSceneWillEnterForeground { [weak presenter] in
			presenter?.sceneWillEnterForeground()
		}
	}
}
