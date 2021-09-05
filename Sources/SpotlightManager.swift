//
//  SpotlightManager.swift
//  Pomogator
//
//  Created by Anvipo on 24.01.2023.
//

import CoreSpotlight

final class SpotlightManager {
	private let searchableIndex: CSSearchableIndex

	init(searchableIndex: CSSearchableIndex) {
		self.searchableIndex = searchableIndex
	}
}

extension SpotlightManager {
	func index(textSearchableItems: [SpotlightSearchableItem]) async throws {
		try await searchableIndex.deleteSearchableItems(withDomainIdentifiers: textSearchableItems.map(\.domainIdentifier))
		try await searchableIndex.deleteSearchableItems(withIdentifiers: textSearchableItems.map(\.uniqueIdentifier))

		let searchableItems = textSearchableItems.map { textSearchableItem in
			let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
			attributeSet.title = textSearchableItem.attributes.title
			attributeSet.contentDescription = textSearchableItem.attributes.contentDescription
			attributeSet.thumbnailData = textSearchableItem.attributes.thumbnailData
			attributeSet.keywords = textSearchableItem.attributes.keywords

			let item = CSSearchableItem(
				uniqueIdentifier: textSearchableItem.uniqueIdentifier,
				domainIdentifier: textSearchableItem.domainIdentifier,
				attributeSet: attributeSet
			)
			item.expirationDate = textSearchableItem.expirationDate

			return item
		}

		try await searchableIndex.indexSearchableItems(searchableItems)
	}
}
