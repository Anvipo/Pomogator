//
//  IFieldItemDelegate.swift
//  App
//
//  Created by Anvipo on 26.09.2021.
//

protocol IFieldItemDelegate: AnyObject {
	func fieldItem<ID: IDType>(_ item: FieldItem<ID>, didTapAccessoryButton button: Button)
}
