//
//  PickerFieldItem.Content.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//

import UIKit

extension PickerFieldItem {
	struct Content<T: PickerFieldItemPresentable>: Hashable {
		let icon: UIImage
		let title: String
		let data: [[T]]
	}
}
