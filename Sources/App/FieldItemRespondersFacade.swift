//
//  FieldItemRespondersFacade.swift
//  App
//
//  Created by Anvipo on 11.09.2021.
//

import UIKit

final class FieldItemRespondersFacade {
	var responderProvider: (() -> UIResponder?)?
	var nextResponderProvider: (() -> UIResponder?)?
}
