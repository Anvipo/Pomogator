//
//  MainVC.swift
//  Pomogator
//
//  Created by Anvipo on 14.01.2023.
//

import UIKit

// swiftlint:disable:next file_types_order
private extension String {
	static var cellReuseID: Self {
		"UITableViewCell"
	}

	static var headerFooterViewReuseID: Self {
		"UITableViewHeaderFooterView"
	}
}

final class MainVC: BaseVC {
	private let presenter: MainPresenter

	private lazy var tableViewDataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
		self?.cellProvider(tableView: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
	}

	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	init(presenter: MainPresenter) {
		self.presenter = presenter

		super.init(output: presenter)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		presenter.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter.viewWillAppear()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupTableViewContentInsets()
	}
}

extension MainVC {
	typealias SectionType = MainSection

	func set(snapshotData: [SectionType.SnapshotData]) {
		var snapshot = Snapshot()
		snapshot.appendSections(snapshotData.map(\.sectionID))
		for sectionData in snapshotData {
			snapshot.appendItems(sectionData.itemIDs, toSection: sectionData.sectionID)
		}
		tableViewDataSource.apply(snapshot, animatingDifferences: shouldAnimateTableViewDifferences)
	}
}

extension MainVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let headerItemModel = presenter.headerItemModel(at: section) else {
			return nil
		}

		return tableView.dequeueAndConfigureHeaderFooterView(reuseID: .headerFooterViewReuseID, item: headerItemModel)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: shouldAnimateTableViewDifferences)

		guard let itemIdentifier = tableViewDataSource.itemIdentifier(for: indexPath) else {
			assertionFailure("?")
			return
		}

		presenter.didTapItem(with: itemIdentifier, at: indexPath)
	}
}

private extension MainVC {
	typealias SectionIdentifierType = MainSectionIdentifier
	typealias DataSource = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
	typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
	typealias ItemIdentifierType = MainItemIdentifier

	var shouldAnimateTableViewDifferences: Bool {
		isViewVisible && !tableView.isHidden
	}

	func setupTableViewContentInsets() {
		tableView.contentInset.bottom = view.safeAreaInsets.bottom
		tableView.centerContentVerticallyIfNeeded()
		tableView.verticalScrollIndicatorInsets.bottom = tableView.contentInset.bottom
	}

	func cellProvider(
		tableView: UITableView,
		indexPath: IndexPath,
		itemIdentifier: ItemIdentifierType
	) -> UITableViewCell? {
		guard let itemModel = presenter.itemModel(by: itemIdentifier, at: indexPath) else {
			return nil
		}

		return tableView.dequeueAndConfigureCell(reuseID: .cellReuseID, indexPath: indexPath, item: itemModel)
	}

	func setupUI() {
		view.backgroundColor = .systemGroupedBackground
		navigationItem.title = String(localized: "Main")

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: .cellReuseID)
		tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: .headerFooterViewReuseID)
		tableView.delegate = self

		view.addSubviewsForConstraintsUse([tableView])

		NSLayoutConstraint.activate(
			tableView.makeSameAnchorConstraints(
				to: view.safeAreaLayoutGuide,
				info: .edgesEqual()
			)
		)
	}
}
