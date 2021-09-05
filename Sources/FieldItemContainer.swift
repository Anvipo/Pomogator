//
//  FieldItemContainer.swift
//  Pomogator
//
//  Created by Anvipo on 10.09.2022.
//

import UIKit

@MainActor
protocol FieldItemContainer {
	var toolbarItems: [UIBarButtonItem] { get set }
	var currentResponderProvider: CurrentResponderProvider { get }
	var respondersNavigationFacade: RespondersNavigationFacade? { get set }
}
