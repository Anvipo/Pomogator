//
//  VychislyatorFormulasListVC.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

final class VychislyatorFormulasListVC: BaseVC {
	private let presenter: VychislyatorFormulasListPresenter

	private lazy var tableViewDataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
		self?.cellProvider(tableView: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
	}

	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	init(presenter: VychislyatorFormulasListPresenter) {
		self.presenter = presenter
		super.init(output: presenter)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		presenter.viewDidLoad()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupCollectionViewContentInsets()
	}
}

extension VychislyatorFormulasListVC {
	typealias SectionType = VychislyatorFormulasListSection

	func set(snapshotData: [SectionType.SnapshotData]) {
		var snapshot = Snapshot()
		snapshot.appendSections(snapshotData.map(\.sectionID))
		for sectionData in snapshotData {
			snapshot.appendItems(sectionData.itemIDs, toSection: sectionData.sectionID)
		}
		tableViewDataSource.apply(snapshot, animatingDifferences: isViewVisible)
	}
}

private extension VychislyatorFormulasListVC {
	typealias SectionIdentifierType = VychislyatorFormulasListSectionIdentifier
	typealias DataSource = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
	typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
	typealias ItemIdentifierType = VychislyatorFormulasListItemIdentifier

	func setupUI() {
		navigationItem.title = String(localized: "Formula list")

		tableView.delaysContentTouches = false
		tableView.allowsSelection = false
		tableView.separatorColor = .clear

		view.addSubviewForConstraintsUse(tableView)

		NSLayoutConstraint.activate(tableView.makeSameAnchorConstraints(to: view.safeAreaLayoutGuide, info: .edgesEqual()))
	}

	func setupCollectionViewContentInsets() {
		tableView.centerContentVerticallyIfNeeded()
	}

	func cellProvider(
		tableView: UITableView,
		indexPath: IndexPath,
		itemIdentifier: ItemIdentifierType
	) -> UITableViewCell? {
		guard let itemModel = presenter.itemModel(by: itemIdentifier, at: indexPath) else {
			return nil
		}

		return tableView.dequeueAndConfigureCell(indexPath: indexPath, item: itemModel)
	}
}
