//
//  TableViewSection.swift
//  Pomogator
//
//  Created by Anvipo on 10.09.2022.
//

import Foundation

struct TableViewSection<SectionID: Hashable, ItemID: Hashable>: TableViewSectionProtocol {
	var headerItem: TableViewHeaderFooterItemProtocol?
	let id: SectionID
	var items: [AnyTableItem<ItemID>] {
		didSet {
			if items.isEmpty {
				assertionFailure(InitError.emptyItems.localizedDescription)
			}
		}
	}

	init(
		id: SectionID,
		items: [AnyTableItem<ItemID>],
		headerItem: TableViewHeaderFooterItemProtocol? = nil
	) throws {
		if items.isEmpty {
			let error = InitError.emptyItems
			assertionFailure(error.localizedDescription)
			throw error
		}

		self.headerItem = headerItem
		self.id = id
		self.items = items
	}

	init(
		id: SectionID,
		items: [any TableViewItemProtocol],
		headerItem: TableViewHeaderFooterItemProtocol? = nil
	) throws {
		try self.init(
			id: id,
			items: items.map(AnyTableItem.init(_:)),
			headerItem: headerItem
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
