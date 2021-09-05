//
//  PoedatorYourMealTimeListVC.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
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

final class PoedatorYourMealTimeListVC: BaseVC {
	private let presenter: PoedatorYourMealTimeListPresenter

	private lazy var tableViewDataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
		self?.cellProvider(tableView: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
	}

	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	private lazy var addMealTimeRemindersButton = Button(
		fullConfiguration: .init(
			uiConfiguration: Pomogator.defaultButtonConfiguration(title: String(localized: "Add notifications")),
			uiConfigurationUpdateHandler: Pomogator.defaultUIConfigurationUpdateHandler(button:)
		) { [weak self] _ in
			self?.presenter.didTapAddRemindersButton()
		}
	)
	private lazy var goToNextScreenButton = Button(
		fullConfiguration: .init(
			uiConfiguration: Pomogator.defaultButtonConfiguration(title: String(localized: "Calculate meal time schedule")),
			uiConfigurationUpdateHandler: Pomogator.defaultUIConfigurationUpdateHandler(button:)
		) { [weak self] _ in
			self?.presenter.goToNextScreen()
		}
	)
	// swiftlint:disable:next force_try
	private lazy var buttonsView = try! ButtonsView(buttons: [addMealTimeRemindersButton, goToNextScreenButton])
	private lazy var emptyView = EmptyView()

	init(
		presenter: PoedatorYourMealTimeListPresenter
	) {
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

extension PoedatorYourMealTimeListVC {
	typealias SectionType = PoedatorYourMealTimeListSection

	func showEmptyStateUI() {
		tableView.set(isHidden: true, animated: isViewVisible)
		emptyView.set(isHidden: false, animated: isViewVisible)
		view.set(backgroundColor: .systemBackground, animated: isViewVisible)
		navigationItem.leftBarButtonItem?.isHidden = true
		navigationItem.rightBarButtonItem?.image = Image.plus.uiImage

		splitViewController?.hideDetailViewController()
	}

	func showMealTimeListUI() {
		emptyView.set(isHidden: true, animated: isViewVisible)
		view.set(backgroundColor: .systemGroupedBackground, animated: isViewVisible)
		tableView.set(isHidden: false, animated: isViewVisible)
		navigationItem.leftBarButtonItem?.isHidden = false
		navigationItem.rightBarButtonItem?.image = Image.pencil.uiImage
	}

	func showAddMealTimeRemindersButton() {
		// swiftlint:disable:next trailing_closure
		addMealTimeRemindersButton.set(
			isHidden: false,
			animated: isViewVisible,
			additionalAnimations: { [weak self] in
				self?.setupTableViewContentInsets()
			}
		)
	}

	func hideAddMealTimeRemindersButton() {
		// swiftlint:disable:next trailing_closure
		addMealTimeRemindersButton.set(
			isHidden: true,
			animated: isViewVisible,
			additionalAnimations: { [weak self] in
				self?.addMealTimeRemindersButton.isHidden = true
				self?.setupTableViewContentInsets()
			}
		)
	}

	func set(snapshotData: [SectionType.SnapshotData]) {
		var snapshot = Snapshot()
		snapshot.appendSections(snapshotData.map(\.sectionID))
		for sectionData in snapshotData {
			snapshot.appendItems(sectionData.itemIDs, toSection: sectionData.sectionID)
		}
		tableViewDataSource.apply(snapshot, animatingDifferences: shouldAnimateTableViewDifferences)
	}
}

extension PoedatorYourMealTimeListVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let headerItemModel = presenter.headerItemModel(at: section) else {
			return nil
		}

		return tableView.dequeueAndConfigureHeaderFooterView(reuseID: .headerFooterViewReuseID, item: headerItemModel)
	}
}

private extension PoedatorYourMealTimeListVC {
	typealias SectionIdentifierType = PoedatorYourMealTimeListSectionIdentifier
	typealias DataSource = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
	typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
	typealias ItemIdentifierType = PoedatorYourMealTimeListItemIdentifier

	var shouldAnimateTableViewDifferences: Bool {
		isViewVisible && !tableView.isHidden
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

	func setupTableViewContentInsets() {
		tableView.contentInset.bottom = tableView.safeAreaInsets.bottom
		tableView.centerContentVerticallyIfNeeded()
		tableView.verticalScrollIndicatorInsets.bottom = tableView.contentInset.bottom
	}

	func setupUI() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: Image.trash.uiImage,
			primaryAction: UIAction { [weak self] _ in
				self?.presenter.didTapDeleteRemindersAndMealTimeListButton()
			}
		)
		navigationItem.leftBarButtonItem?.tintColor = .systemRed
		navigationItem.title = String(localized: "Meal time schedule")
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: Image.plus.uiImage,
			primaryAction: UIAction { [weak self] _ in
				self?.presenter.goToNextScreen()
			}
		)

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: .cellReuseID)
		tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: .headerFooterViewReuseID)
		tableView.isHidden = true
		tableView.allowsSelection = false
		tableView.delegate = self

		addMealTimeRemindersButton.isHidden = true

		emptyView.isHidden = true

		view.addSubviewsForConstraintsUse([tableView, buttonsView, emptyView])

		NSLayoutConstraint.activate(
			tableView.makeSameAnchorConstraints(
				to: view.safeAreaLayoutGuide,
				info: .equal(leading: 0, top: 0, trailing: 0)
			) +
			tableView.makeSameAnchorConstraints(
				to: view,
				info: .equal(bottom: 0)
			) +
			buttonsView.makeSameAnchorConstraints(
				to: view.safeAreaLayoutGuide,
				info: .equal(leading: 0, trailing: 0)
			) +
			buttonsView.makeSameAnchorConstraints(
				to: view,
				info: .equal(bottom: 0)
			) +
			emptyView.makeSameAnchorConstraints(
				to: view.safeAreaLayoutGuide,
				info: .center(insets: .default)
			)
		)
	}
}
