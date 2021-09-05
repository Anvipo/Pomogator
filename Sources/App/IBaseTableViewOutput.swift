//
//  IBaseTableViewOutput.swift
//  App
//
//  Created by Anvipo on 17.02.2023.
//

import Foundation

protocol IBaseTableViewOutput<ItemIdentifierType>: IBaseViewOutput {
	associatedtype SectionIdentifierType: Hashable, Sendable
	associatedtype ItemIdentifierType: Hashable, Sendable

	func headerItemModel(at sectionIndex: Int) -> (any IReusableTableViewHeaderFooterItem)?
	func sectionModel(at sectionIndex: Int) -> TableViewSection<SectionIdentifierType, ItemIdentifierType>?
	func itemModel(by id: ItemIdentifierType, at indexPath: IndexPath) -> (any IReusableTableViewItem)?
	func footerItemModel(at sectionIndex: Int) -> (any IReusableTableViewHeaderFooterItem)?

	func didTapItem(with itemIdentifier: ItemIdentifierType, at indexPath: IndexPath)
}

extension IBaseTableViewOutput {
	func headerItemModel(at sectionIndex: Int) -> (any IReusableTableViewHeaderFooterItem)? {
		sectionModel(at: sectionIndex)?.headerItem
	}

	func itemModel(
		by id: ItemIdentifierType,
		at indexPath: IndexPath
	) -> (any IReusableTableViewItem)? {
		guard let section = sectionModel(at: indexPath.section) else {
			return nil
		}

		guard let appropriateItem = section.items.first(where: { $0.id == id }) else {
			assertionFailure("Такого item с таким id нету в секции - id = \(id)")
			return nil
		}

		return appropriateItem.base
	}

	func footerItemModel(at sectionIndex: Int) -> (any IReusableTableViewHeaderFooterItem)? {
		sectionModel(at: sectionIndex)?.footerItem
	}

	// swiftlint:disable:next unused_parameter no_empty_block
	func didTapItem(with itemIdentifier: ItemIdentifierType, at indexPath: IndexPath) {}
}
