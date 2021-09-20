//
//  PickerFieldItemContainer.swift
//  Pomogator
//
//  Created by Anvipo on 03.09.2022.
//

import UIKit

@MainActor
protocol PickerFieldItemContainer {
	var icon: UIImage { get }

	var title: String { get }

	var numberOfComponents: Int { get }

	func numberOfRows(in component: Int) -> Int

	func text<ID: IDType>(for selectedComponent: PickerFieldItem<ID>.SelectedComponentInfo) -> String
}
