//
//  IAppTabBarCoordinatorAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 24.01.2023.
//

import Foundation

protocol IAppTabBarCoordinatorAssembly {
	var spotlightSearchableItems: [SpotlightSearchableItem] { get }
}

extension IAppTabBarCoordinatorAssembly {
	func defaultSpotlightSearchableItem(
		contentDescription: String,
		keywords: [String],
		thumbnailData: Data?,
		title: String,
		uniqueIdentifier: String,
		expirationDate: Date? = .distantFuture
	) -> SpotlightSearchableItem {
		.init(
			attributes: .init(
				contentDescription: contentDescription,
				keywords: keywords,
				thumbnailData: thumbnailData,
				title: title
			),
			domainIdentifier: "ru.anvipo.pomogator",
			expirationDate: expirationDate,
			uniqueIdentifier: uniqueIdentifier
		)
	}
}
