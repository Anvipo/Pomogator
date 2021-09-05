//
//  TableViewSection.swift
//  App
//
//  Created by Anvipo on 10.09.2022.
//

import Foundation

struct TableViewSection<SectionID: IDType, ItemID: IDType> {
	var headerItem: (any IReusableTableViewHeaderFooterItem)?
	var footerItem: (any IReusableTableViewHeaderFooterItem)?
	let id: SectionID
	var items: [AnyTableViewItem<ItemID>] {
		didSet {
			if items.isEmpty {
				assertionFailure(InitError.emptyItems.localizedDescription)
			}
		}
	}

	init(
		id: SectionID,
		items: [AnyTableViewItem<ItemID>],
		headerItem: (any IReusableTableViewHeaderFooterItem)? = nil,
		footerItem: (any IReusableTableViewHeaderFooterItem)? = nil
	) throws {
		if items.isEmpty {
			let error = InitError.emptyItems
			assertionFailure(error.localizedDescription)
			throw error
		}

		self.headerItem = headerItem
		self.footerItem = footerItem
		self.id = id
		self.items = items
	}

	init(
		id: SectionID,
		items: [any IReusableTableViewItem],
		headerItem: (any IReusableTableViewHeaderFooterItem)? = nil,
		footerItem: (any IReusableTableViewHeaderFooterItem)? = nil
	) throws {
		try self.init(
			id: id,
			items: items.map { AnyTableViewItem($0) },
			headerItem: headerItem,
			footerItem: footerItem
		)
	}
}

extension TableViewSection {
	struct SnapshotData {
		let sectionID: SectionID
		let itemIDs: [ItemID]
	}

	var snapshotData: SnapshotData {
		.init(sectionID: id, itemIDs: items.map(\.id))
	}
}
