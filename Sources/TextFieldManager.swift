//
//  TextFieldManager.swift
//  Pomogator
//
//  Created by Anvipo on 05.04.2021.
//

import Combine
import Foundation

final class TextFieldManager: ObservableObject {
	let id: UUID

	@Published var inputedText: String {
		didSet {
			if let delegate = delegate,
			   !delegate.textFieldManagerShouldChange(self, oldText: oldValue, to: inputedText) {
				inputedText = oldValue
			}

			delegate?.textFieldManagerDidChangeText(self)
		}
	}

	weak var delegate: TextFieldManagerDelegate?

	init(
		id: UUID,
		inputedText: String = ""
	) {
		self.id = id
		self.inputedText = inputedText
	}
}
