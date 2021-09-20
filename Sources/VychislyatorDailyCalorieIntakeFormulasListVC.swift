//
//  VychislyatorDailyCalorieIntakeFormulasListVC.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

import UIKit

final class VychislyatorDailyCalorieIntakeFormulasListVC: BaseVC {
	private let presenter: VychislyatorDailyCalorieIntakeFormulasListPresenter

	private lazy var tableViewDataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
		self?.cellProvider(tableView: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
	}

	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	private lazy var saveButton = Button(
		fullConfiguration: .init(
			uiConfiguration: Pomogator.defaultButtonConfiguration(
				title: String(localized: "Save daily calorie intake value")
			),
			uiConfigurationUpdateHandler: Pomogator.defaultUIConfigurationUpdateHandler(button:)
		) { [weak self] _ in
			self?.presenter.didTapSaveButton()
		}
	)
	// swiftlint:disable:next force_try
	private lazy var buttonsView = try! ButtonsView(buttons: [saveButton])

	init(presenter: VychislyatorDailyCalorieIntakeFormulasListPresenter) {
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

extension VychislyatorDailyCalorieIntakeFormulasListVC {
	typealias SectionType = VychislyatorDailyCalorieIntakeFormulasListSection

	func set(snapshotData: [SectionType.SnapshotData]) {
		var snapshot = Snapshot()
		snapshot.appendSections(snapshotData.map(\.sectionID))
		for sectionData in snapshotData {
			snapshot.appendItems(sectionData.itemIDs, toSection: sectionData.sectionID)
		}
		tableViewDataSource.apply(snapshot, animatingDifferences: isViewVisible)
	}

	func reconfigure(items: [VychislyatorDailyCalorieIntakeFormulasListItemIdentifier]) {
		var snapshot = tableViewDataSource.snapshot()
		snapshot.reconfigureItems(items)
		tableViewDataSource.apply(snapshot, animatingDifferences: isViewVisible)
	}

	func showSaveDailyCalorieIntakeButton() {
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

	func hideSaveDailyCalorieIntakeButton() {
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

	func showDeleteSavedValuesButton() {
		navigationItem.rightBarButtonItem?.isHidden = false
	}

	func hideDeleteSavedValuesButton() {
		navigationItem.rightBarButtonItem?.isHidden = true
	}
}

extension VychislyatorDailyCalorieIntakeFormulasListVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let headerItemModel = presenter.headerItemModel(at: section) else {
			return nil
		}

		return tableView.dequeueAndConfigureHeaderFooterView(item: headerItemModel)
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		guard let footerItemModel = presenter.footerItemModel(at: section) else {
			return nil
		}

		return tableView.dequeueAndConfigureHeaderFooterView(item: footerItemModel)
	}
}

private extension VychislyatorDailyCalorieIntakeFormulasListVC {
	typealias SectionIdentifierType = VychislyatorDailyCalorieIntakeFormulasListSectionIdentifier
	typealias DataSource = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
	typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
	typealias ItemIdentifierType = VychislyatorDailyCalorieIntakeFormulasListItemIdentifier

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
		if splitViewController != nil {
			navigationItem.leftBarButtonItem = UIBarButtonItem(
				systemItem: .close,
				primaryAction: UIAction { [weak self] _ in
					self?.splitViewController?.hideDetailViewController()
				}
			)
		}

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: Image.trash.uiImage,
			primaryAction: UIAction { [weak self] _ in
				self?.presenter.didTapDeleteSavedValues()
			}
		)
		navigationItem.rightBarButtonItem?.tintColor = .systemRed
		hideDeleteSavedValuesButton()

		navigationItem.title = String(localized: "Daily calorie intake")

		addTapGestureForHidingKeyboard()

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
