//
//  TextFieldManagerDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 05.04.2021.
//

protocol TextFieldManagerDelegate: AnyObject {
	func textFieldManagerShouldChange(
		_ textFieldManager: TextFieldManager,
		oldText: String,
		to newText: String
	) -> Bool

	func textFieldManagerDidChangeText(_ textFieldManager: TextFieldManager)
}

extension TextFieldManagerDelegate {
	func textFieldManagerDidChangeText(_ textFieldManager: TextFieldManager) {
		// no code
	}
}
