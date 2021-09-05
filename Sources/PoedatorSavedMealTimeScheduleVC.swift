//
//  PoedatorSavedMealTimeScheduleVC.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class PoedatorSavedMealTimeScheduleVC: BaseVC {
	private let presenter: PoedatorSavedMealTimeSchedulePresenter

	private lazy var tableViewDataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
		self?.cellProvider(tableView: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
	}

	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	private lazy var addMealTimeRemindersButton = Button(
		fullConfiguration: .init(
			uiConfiguration: Pomogator.defaultButtonConfiguration(
				title: String(localized: "Add meal time notifications button title")
			),
			uiConfigurationUpdateHandler: Pomogator.defaultUIConfigurationUpdateHandler(button:)
		) { [weak self] _ in
			self?.presenter.didTapAddRemindersButton()
		}
	)
	// swiftlint:disable:next force_try
	private lazy var buttonsView = try! ButtonsView(buttons: [addMealTimeRemindersButton])
	private lazy var emptyView = EmptyView()

	init(
		presenter: PoedatorSavedMealTimeSchedulePresenter
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

extension PoedatorSavedMealTimeScheduleVC {
	typealias SectionType = PoedatorSavedMealTimeScheduleSection

	func showEmptyStateUI() {
		tableView.set(isHidden: true, animated: isViewVisible)
		emptyView.set(isHidden: false, animated: isViewVisible)
		hideAddMealTimeRemindersButton()
		view.set(backgroundColor: .systemBackground, animated: isViewVisible)
		navigationItem.leftBarButtonItem?.isHidden = true
		navigationItem.rightBarButtonItem?.image = Image.plus.uiImage

		splitViewController?.hideDetailVC()
	}

	func showMealTimeScheduleUI() {
		emptyView.set(isHidden: true, animated: isViewVisible)
		view.set(backgroundColor: .systemGroupedBackground, animated: isViewVisible)
		tableView.set(isHidden: false, animated: isViewVisible)
		navigationItem.leftBarButtonItem?.isHidden = false
		navigationItem.rightBarButtonItem?.image = Image.pencil.uiImage
	}

	func showAddMealTimeRemindersButton() {
		// swiftlint:disable:next trailing_closure
		buttonsView.set(
			isHidden: false,
			animated: isViewVisible,
			additionalAnimations: { [weak self] in
				self?.setupTableViewContentInsets()
			}
		)
	}

	func hideAddMealTimeRemindersButton() {
		// swiftlint:disable:next trailing_closure
		buttonsView.set(
			isHidden: true,
			animated: isViewVisible,
			additionalAnimations: { [weak self] in
				self?.buttonsView.isHidden = true
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

extension PoedatorSavedMealTimeScheduleVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let headerItemModel = presenter.headerItemModel(at: section) else {
			return nil
		}

		return tableView.dequeueAndConfigureHeaderFooterView(item: headerItemModel)
	}
}

private extension PoedatorSavedMealTimeScheduleVC {
	typealias SectionIdentifierType = PoedatorSavedMealTimeScheduleSectionIdentifier
	typealias DataSource = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
	typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
	typealias ItemIdentifierType = PoedatorSavedMealTimeScheduleItemIdentifier

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

		return tableView.dequeueAndConfigureCell(indexPath: indexPath, item: itemModel)
	}

	func setupTableViewContentInsets() {
		let neededBottomInset: CGFloat
		if buttonsView.isHidden {
			neededBottomInset = 0
		} else {
			neededBottomInset = buttonsView.frame.height - view.safeAreaInsets.bottom
		}

		tableView.contentInset.bottom = neededBottomInset
		tableView.centerContentVerticallyIfNeeded()
		tableView.verticalScrollIndicatorInsets.bottom = tableView.contentInset.bottom
	}

	func setupUI() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: Image.trash.uiImage,
			primaryAction: UIAction { [weak self] _ in
				self?.presenter.didTapDeleteRemindersAndMealTimeScheduleButton()
			}
		)
		navigationItem.leftBarButtonItem?.tintColor = .systemRed
		navigationItem.title = String(localized: "Meal time schedule screen title")
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: Image.plus.uiImage,
			primaryAction: UIAction { [weak self] _ in
				self?.presenter.goToNextScreen()
			}
		)

		tableView.isHidden = true
		tableView.allowsSelection = false
		tableView.delegate = self

		tableViewDataSource.defaultRowAnimation = .fade

		buttonsView.isHidden = true

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
