//
//  TableViewSectionProtocol.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2022.
//

protocol TableViewSectionProtocol {
	associatedtype SectionID: Hashable
	associatedtype ItemID: Hashable

	var id: SectionID { get }
	var headerItem: TableViewHeaderFooterItemProtocol? { get }
	var items: [AnyTableItem<ItemID>] { get }
}

extension TableViewSectionProtocol {
	var headerItem: TableViewHeaderFooterItemProtocol? { nil }
}
