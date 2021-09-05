//
//  TableViewCellAccessoryInfo.swift
//  App
//
//  Created by Anvipo on 16.01.2023.
//

import UIKit

enum TableViewCellAccessoryInfo {
	case accessoryType(UITableViewCell.AccessoryType)
	case accessoryImage(UIImage, adjustsImageSizeForAccessibilityContentSizeCategory: Bool)
}

extension UITableViewCell {
	func updateAccessory(with accessoryInfo: TableViewCellAccessoryInfo?) {
		accessoryType = .none
		accessoryView = nil

		if let accessoryInfo {
			switch accessoryInfo {
			case .accessoryType(let accessoryType):
				self.accessoryType = accessoryType

			case let .accessoryImage(accessoryImage, adjustsImageSizeForAccessibilityContentSizeCategory):
				accessoryView = UIImageView(image: accessoryImage).apply { accessoryImageView in
					accessoryImageView.adjustsImageSizeForAccessibilityContentSizeCategory = adjustsImageSizeForAccessibilityContentSizeCategory
				}
			}
		}
	}
}
