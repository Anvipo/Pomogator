//
//  ISwitchFieldItemDelegate.swift
//  App
//
//  Created by Anvipo on 12.03.2023.
//

protocol ISwitchFieldItemDelegate: IFieldItemDelegate {
	func switchFieldItemDidChangeValue<ID: IDType>(_ item: SwitchFieldItem<ID>)
}
