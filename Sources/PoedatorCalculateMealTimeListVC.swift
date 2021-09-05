//
//  PoedatorCalculateMealTimeListVC.swift
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

final class PoedatorCalculateMealTimeListVC: BaseVC {
	private let presenter: PoedatorCalculateMealTimeListPresenter

	private lazy var tableViewDataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
		self?.cellProvider(tableView: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
	}
	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	private lazy var saveButton = Button(
		fullConfiguration: .init(
			uiConfiguration: Pomogator.defaultButtonConfiguration(
				title: String(localized: "Save calculated schedule")
			),
			uiConfigurationUpdateHandler: Pomogator.defaultUIConfigurationUpdateHandler(button:)
		) { [weak self] _ in
			self?.presenter.didTapSaveButton()
		}
	)
	// swiftlint:disable:next force_try
	private lazy var buttonsView = try! ButtonsView(buttons: [saveButton])

	private var keyboardHeight: CGFloat

	// swiftlint:disable:next function_body_length
	init(
		presenter: PoedatorCalculateMealTimeListPresenter
	) {
		self.presenter = presenter
		keyboardHeight = 0

		super.init(output: presenter)

		observeKeyboardWillShow { [weak self] result in
			guard let self else {
				return
			}

			guard let notification = result.value else {
				assertionFailure("?")
				return
			}

			if notification.frameBegin == notification.frameEnd {
				return
			}

			self.keyboardHeight = notification.frameEnd.height

			if self.isViewVisible {
				self.view.layoutIfNeeded()

				UIViewPropertyAnimator(keyboardNotification: notification) {
					self.setupTableViewContentInsets()
					self.view.layoutIfNeeded()
				}.startAnimation()
			} else {
				self.view.setNeedsLayout()
				self.setupTableViewContentInsets()
				self.view.setNeedsLayout()
			}
		}

		observeKeyboardWillHide { [weak self] result in
			guard let self else {
				return
			}

			guard let notification = result.value else {
				assertionFailure("?")
				return
			}

			if notification.frameBegin == notification.frameEnd {
				return
			}

			self.keyboardHeight = 0

			if self.isViewVisible {
				self.view.layoutIfNeeded()

				UIViewPropertyAnimator(keyboardNotification: notification) {
					self.setupTableViewContentInsets()
					self.view.layoutIfNeeded()
				}.startAnimation()
			} else {
				self.view.setNeedsLayout()
				self.setupTableViewContentInsets()
				self.view.setNeedsLayout()
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		presenter.viewDidLoad()
	}
}

extension PoedatorCalculateMealTimeListVC {
	typealias SectionType = PoedatorCalculateMealTimeListSection
	typealias SectionIdentifierType = PoedatorCalculateMealTimeListSectionIdentifier
	typealias ItemIdentifierType = PoedatorCalculateMealTimeListItemIdentifier

	func set(snapshotData: [SectionType.SnapshotData]) {
		for sectionIndex in 0..<tableView.numberOfSections {
			guard let headerItemModel = presenter.headerItemModel(at: sectionIndex),
				  let headerView = tableView.headerView(forSection: sectionIndex)
			else {
				continue
			}

			// обновляем хедеры вручную, т.к. diffable data source не обновляет их
			// и при изменении текста, он никак не обновляется((
			headerItemModel.update(headerFooterView: headerView)
		}

		var snapshot = Snapshot()

		snapshot.appendSections(snapshotData.map(\.sectionID))
		for sectionData in snapshotData {
			snapshot.appendItems(sectionData.itemIDs, toSection: sectionData.sectionID)
		}
		tableViewDataSource.apply(snapshot, animatingDifferences: isViewVisible)
	}

	func showSaveCalculatedMealTimeListButton() {
		UIView.animate(withDuration: preferredAnimationDuration) { [self] in
			buttonsView.alpha = 1
		}
	}

	func hideSaveCalculatedMealTimeListButton() {
		UIView.animate(withDuration: preferredAnimationDuration) { [self] in
			buttonsView.alpha = 0
		}
	}
}

extension PoedatorCalculateMealTimeListVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let headerItemModel = presenter.headerItemModel(at: section) else {
			return nil
		}

		return tableView.dequeueAndConfigureHeaderFooterView(reuseID: .headerFooterViewReuseID, item: headerItemModel)
	}
}

private extension PoedatorCalculateMealTimeListVC {
	typealias DataSource = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
	typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>

	var neededTableViewBottomInset: CGFloat {
		let bottomViewHeight = keyboardHeight.isZero ? buttonsView.frame.height : keyboardHeight

		return bottomViewHeight - view.safeAreaInsets.bottom
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
		tableView.contentInset.bottom = neededTableViewBottomInset
		tableView.verticalScrollIndicatorInsets.bottom = tableView.contentInset.bottom
	}

	func setupUI() {
		addTapGestureForHidingKeyboard()

		if splitViewController != nil {
			navigationItem.leftBarButtonItem = UIBarButtonItem(
				systemItem: .close,
				primaryAction: UIAction { [weak self] _ in
					self?.splitViewController?.hideDetailViewController()
				}
			)
		}
		navigationItem.title = String(localized: "Calculate meal time schedule")

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: .cellReuseID)
		tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: .headerFooterViewReuseID)
		tableView.delegate = self
		tableView.allowsSelection = false

		tableViewDataSource.defaultRowAnimation = .fade

		view.backgroundColor = .systemGroupedBackground

		hideSaveCalculatedMealTimeListButton()

		view.addSubviewsForConstraintsUse([tableView, buttonsView])

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
			)
		)
	}
}
