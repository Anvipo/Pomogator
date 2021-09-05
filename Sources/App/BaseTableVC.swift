//
//  BaseTableVC.swift
//  App
//
//  Created by Anvipo on 17.02.2023.
//

import UIKit

class BaseTableVC<
	SectionIdentifierType: Hashable & Sendable,
	ItemIdentifierType: Hashable & Sendable
>: BaseVC, UITableViewDelegate {
	private lazy var tableViewDataSource = makeDataSource()

	lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	var ignoreTableViewVisibilityInShouldAnimate: Bool

	override var shouldAnimate: Bool {
		if ignoreTableViewVisibilityInShouldAnimate {
			return super.shouldAnimate
		}

		return super.shouldAnimate && !tableView.isHidden && tableView.isAddedToWindow
	}

	private var output: (any IBaseTableViewOutput<ItemIdentifierType>)?

	init(output: (any IBaseTableViewOutput<ItemIdentifierType>)? = nil) {
		self.output = output

		ignoreTableViewVisibilityInShouldAnimate = false

		super.init(output: output)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let headerItemModel = output?.headerItemModel(at: section) else {
			return nil
		}

		return tableView.dequeueAndConfigureHeaderFooterView(item: headerItemModel)
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		guard let footerItemModel = output?.footerItemModel(at: section) else {
			return nil
		}

		return tableView.dequeueAndConfigureHeaderFooterView(item: footerItemModel)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: shouldAnimate)

		guard let itemIdentifier = tableViewDataSource.itemIdentifier(for: indexPath) else {
			assertionFailure("?")
			return
		}

		output?.didTapItem(with: itemIdentifier, at: indexPath)
	}
}

extension BaseTableVC {
	typealias SectionType = TableViewSection<SectionIdentifierType, ItemIdentifierType>

	func set(
		snapshotData: [SectionType.SnapshotData],
		usingReloadData: Bool = false,
		defaultRowAnimation: UITableView.RowAnimation = .fade,
		estimatedRowHeight: CGFloat = UITableView.automaticDimension
	) {
		tableView.estimatedRowHeight = estimatedRowHeight

		var newSnapshot = Snapshot()
		newSnapshot.appendSections(snapshotData.map(\.sectionID))
		for sectionData in snapshotData {
			newSnapshot.appendItems(sectionData.itemIDs, toSection: sectionData.sectionID)
		}

		if UIAccessibility.isReduceMotionEnabled && UIAccessibility.prefersCrossFadeTransitions {
			tableViewDataSource.defaultRowAnimation = .fade
		} else {
			tableViewDataSource.defaultRowAnimation = defaultRowAnimation
		}

		if usingReloadData {
			// полезно, когда нужно изменить ещё header-ы и footer-ы
			tableViewDataSource.applySnapshotUsingReloadData(newSnapshot)
		} else {
			tableViewDataSource.apply(newSnapshot, animatingDifferences: shouldAnimate)
		}
	}

	func reconfigure(
		itemIdentifiers: [ItemIdentifierType],
		usingReloadData: Bool = false,
		defaultRowAnimation: UITableView.RowAnimation = .fade
	) {
		var newSnapshot = tableViewDataSource.snapshot()

		if newSnapshot.itemIdentifiers.isEmpty && itemIdentifiers.isNotEmpty {
			assertionFailure("?")
		}

		newSnapshot.reconfigureItems(itemIdentifiers)

		if UIAccessibility.isReduceMotionEnabled && UIAccessibility.prefersCrossFadeTransitions {
			tableViewDataSource.defaultRowAnimation = .fade
		} else {
			tableViewDataSource.defaultRowAnimation = defaultRowAnimation
		}

		if usingReloadData {
			// полезно, когда нужно изменить ещё header-ы и footer-ы
			tableViewDataSource.applySnapshotUsingReloadData(newSnapshot)
		} else {
			tableViewDataSource.apply(newSnapshot, animatingDifferences: shouldAnimate)
		}
	}

	func cell(for item: ItemIdentifierType) -> UITableViewCell? {
		guard let itemIndexPath = tableViewDataSource.indexPath(for: item) else {
			return nil
		}

		return tableView.cellForRow(at: itemIndexPath)
	}

	func scroll(to item: ItemIdentifierType, at scrollPosition: UITableView.ScrollPosition) {
		guard let itemIndexPath = tableViewDataSource.indexPath(for: item) else {
			assertionFailure("?")
			return
		}

		tableView.scrollToRow(at: itemIndexPath, at: scrollPosition, animated: shouldAnimate)
	}
}

private extension BaseTableVC {
	typealias DataSource = UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
	typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>

	func cellProvider(
		tableView: UITableView,
		indexPath: IndexPath,
		itemIdentifier: ItemIdentifierType
	) -> UITableViewCell? {
		guard let output,
			  let itemModel = output.itemModel(by: itemIdentifier, at: indexPath)
		else {
			assertionFailure("?")
			return nil
		}

		return tableView.dequeueAndConfigureCell(indexPath: indexPath, item: itemModel)
	}

	func makeDataSource() -> DataSource {
		DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
			self?.cellProvider(tableView: tableView, indexPath: indexPath, itemIdentifier: itemIdentifier)
		}
	}

	func setUpUI() {
		tableView.backgroundColor = .clear
		tableView.delegate = self
	}
}
