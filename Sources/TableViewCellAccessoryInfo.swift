//
//  TableViewCellAccessoryInfo.swift
//  Pomogator
//
//  Created by Anvipo on 16.01.2023.
//

import UIKit

@MainActor
enum TableViewCellAccessoryInfo {
	case accessoryType(UITableViewCell.AccessoryType)
	case accessoryView(UIView)
}

extension TableViewCellAccessoryInfo {
	func update(tableViewCell: UITableViewCell) {
		switch self {
		case .accessoryType(let accessoryType):
			tableViewCell.accessoryType = accessoryType

		case .accessoryView(let accessoryView):
			tableViewCell.accessoryView = accessoryView
		}
	}
}
