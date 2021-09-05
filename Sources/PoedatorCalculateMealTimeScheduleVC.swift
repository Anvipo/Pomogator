//
//  PoedatorCalculateMealTimeScheduleVC.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class PoedatorCalculateMealTimeScheduleVC: BaseVC {
	private let presenter: PoedatorCalculateMealTimeSchedulePresenter

	private lazy var tableViewDataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
		self?.cellProvider(tableView: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
	}
	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	private lazy var saveButton = Button(
		fullConfiguration: .init(
			uiConfiguration: Pomogator.defaultButtonConfiguration(
				title: String(localized: "Save calculated schedule button title")
			),
			uiConfigurationUpdateHandler: Pomogator.defaultUIConfigurationUpdateHandler(button:)
		) { [weak self] _ in
			self?.presenter.didTapSaveButton()
		}
	)
	// swiftlint:disable:next force_try
	private lazy var buttonsView = try! ButtonsView(buttons: [saveButton])

	init(
		presenter: PoedatorCalculateMealTimeSchedulePresenter
	) {
		self.presenter = presenter

		super.init(output: presenter)

		observeKeyboardWillChangeFrame { [weak self] in
			self?.setupTableViewContentInsets()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		presenter.viewDidLoad()
	}
}

extension PoedatorCalculateMealTimeScheduleVC {
	typealias SectionType = PoedatorCalculateMealTimeScheduleSection
	typealias SectionIdentifierType = PoedatorCalculateMealTimeScheduleSectionIdentifier
	typealias ItemIdentifierType = PoedatorCalculateMealTimeScheduleItemIdentifier

	func set(snapshotData: [SectionType.SnapshotData]) {
		for sectionIndex in 0..<tableView.numberOfSections {
			guard let headerItemModel = presenter.headerItemModel(at: sectionIndex),
				  let headerView = tableView.headerView(forSection: sectionIndex)
			else {
				continue
			}

			// обновляем хедеры вручную, т.к. diffable data source не обновляет их
			// и при изменении текста, он никак не обновляется 😞
			headerItemModel.update(headerFooterView: headerView)
		}

		var snapshot = Snapshot()

		snapshot.appendSections(snapshotData.map(\.sectionID))
		for sectionData in snapshotData {
			snapshot.appendItems(sectionData.itemIDs, toSection: sectionData.sectionID)
		}
		tableViewDataSource.apply(snapshot, animatingDifferences: isViewVisible)
	}

	func showSaveCalculatedMealTimeScheduleButton() {
		// swiftlint:disable:next trailing_closure
		buttonsView.set(
			isHidden: false,
			animated: isViewVisible,
			completion: { [weak self] _ in
				guard let self else {
					return
				}

				self.animateIfNeeded {
					self.setupTableViewContentInsets()
				}
			}
		)
	}

	func hideSaveCalculatedMealTimeScheduleButton() {
		// swiftlint:disable:next trailing_closure
		buttonsView.set(
			isHidden: true,
			animated: isViewVisible,
			completion: { [weak self] _ in
				guard let self else {
					return
				}

				self.animateIfNeeded {
					self.setupTableViewContentInsets()
				}
			}
		)
	}
}

extension PoedatorCalculateMealTimeScheduleVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let headerItemModel = presenter.headerItemModel(at: section) else {
			return nil
		}

		return tableView.dequeueAndConfigureHeaderFooterView(item: headerItemModel)
	}
}

private extension PoedatorCalculateMealTimeScheduleVC {
	typealias DataSource = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
	typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>

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
			neededBottomInset = keyboardHeight.isZero ? 0 : keyboardHeight - view.safeAreaInsets.bottom
		} else {
			neededBottomInset = (keyboardHeight.isZero ? buttonsView.frame.height : keyboardHeight) - view.safeAreaInsets.bottom
		}

		tableView.contentInset.bottom = neededBottomInset
		tableView.verticalScrollIndicatorInsets.bottom = tableView.contentInset.bottom
	}

	func setupUI() {
		addTapGestureForHidingKeyboard()

		if splitViewController != nil {
			navigationItem.leftBarButtonItem = UIBarButtonItem(
				systemItem: .close,
				primaryAction: UIAction { [weak self] _ in
					self?.splitViewController?.hideDetailVC()
				}
			)
		}
		navigationItem.title = String(localized: "Calculate meal time schedule screen title")

		tableView.delegate = self
		tableView.allowsSelection = false

		tableViewDataSource.defaultRowAnimation = .fade

		buttonsView.isHidden = true

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
