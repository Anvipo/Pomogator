//
//  AppTabBarCoordinatorAssembly.swift
//  App
//
//  Created by Anvipo on 24.01.2023.
//

import UIKit

class AppTabBarCoordinatorAssembly {}

extension AppTabBarCoordinatorAssembly {
	func makeTabBarItem(title: String, image: Image, tag: Int) -> UITabBarItem {
		let tabBarItemImageSide: CGFloat = 25

		return UITabBarItem(
			title: title,
			image: try! image.uiImage.proportionallyResized(to: .init(side: tabBarItemImageSide)),
			tag: tag
		).apply { tabBarItem in
			let scaledTabBarItemImageSide = FontStyle.caption2.fontMetrics.scaledValue(for: tabBarItemImageSide)
			tabBarItem.largeContentSizeImage = try! image.uiImage.proportionallyResized(to: .init(side: scaledTabBarItemImageSide))
		}
	}

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
