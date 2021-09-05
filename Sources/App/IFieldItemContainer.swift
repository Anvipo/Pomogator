//
//  IFieldItemContainer.swift
//  App
//
//  Created by Anvipo on 10.09.2022.
//

import UIKit

protocol IFieldItemContainer: IItem {
	var fieldItem: FieldItem<ID> { get }
	var accessibilityInfoProvider: FieldItemAccessibilityInfoProvider { get }
	var respondersFacade: FieldItemRespondersFacade { get }
}

extension IFieldItemContainer {
	var id: ID {
		fieldItem.id
	}

	var accessibilityInfoProvider: FieldItemAccessibilityInfoProvider {
		fieldItem.accessibilityInfoProvider
	}

	var respondersFacade: FieldItemRespondersFacade {
		fieldItem.respondersFacade
	}
}
