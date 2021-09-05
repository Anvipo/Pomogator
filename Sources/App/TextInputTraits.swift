//
//  TextInputTraits.swift
//  App
//
//  Created by Anvipo on 28.01.2023.
//

import UIKit

final class TextInputTraits: NSObject, UITextInputTraits {
	var autocapitalizationType: UITextAutocapitalizationType
	var autocorrectionType: UITextAutocorrectionType
	var enablesReturnKeyAutomatically: Bool
	var isSecureTextEntry: Bool
	var keyboardAppearance: UIKeyboardAppearance
	var keyboardType: UIKeyboardType
	var passwordRules: UITextInputPasswordRules?
	var returnKeyType: UIReturnKeyType
	var smartDashesType: UITextSmartDashesType
	var smartInsertDeleteType: UITextSmartInsertDeleteType
	var smartQuotesType: UITextSmartQuotesType
	var spellCheckingType: UITextSpellCheckingType
	var textContentType: UITextContentType?

	init(
		autocapitalizationType: UITextAutocapitalizationType,
		autocorrectionType: UITextAutocorrectionType,
		enablesReturnKeyAutomatically: Bool,
		isSecureTextEntry: Bool,
		keyboardAppearance: UIKeyboardAppearance,
		keyboardType: UIKeyboardType,
		passwordRules: UITextInputPasswordRules?,
		returnKeyType: UIReturnKeyType,
		smartDashesType: UITextSmartDashesType,
		smartInsertDeleteType: UITextSmartInsertDeleteType,
		smartQuotesType: UITextSmartQuotesType,
		spellCheckingType: UITextSpellCheckingType,
		textContentType: UITextContentType?
	) {
		self.autocapitalizationType = autocapitalizationType
		self.autocorrectionType = autocorrectionType
		self.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
		self.isSecureTextEntry = isSecureTextEntry
		self.keyboardAppearance = keyboardAppearance
		self.keyboardType = keyboardType
		self.passwordRules = passwordRules
		self.returnKeyType = returnKeyType
		self.smartDashesType = smartDashesType
		self.smartInsertDeleteType = smartInsertDeleteType
		self.smartQuotesType = smartQuotesType
		self.spellCheckingType = spellCheckingType
		self.textContentType = textContentType
	}
}

extension TextInputTraits {
	static var `default`: Self {
		Self(
			autocapitalizationType: .sentences,
			autocorrectionType: .default,
			enablesReturnKeyAutomatically: false,
			isSecureTextEntry: false,
			keyboardAppearance: .default,
			keyboardType: .default,
			passwordRules: nil,
			returnKeyType: .default,
			smartDashesType: .default,
			smartInsertDeleteType: .default,
			smartQuotesType: .default,
			spellCheckingType: .default,
			textContentType: nil
		)
	}
}

extension UITextField {
	func configure(with textInputTraits: TextInputTraits) {
		autocapitalizationType = textInputTraits.autocapitalizationType
		autocorrectionType = textInputTraits.autocorrectionType
		enablesReturnKeyAutomatically = textInputTraits.enablesReturnKeyAutomatically
		isSecureTextEntry = textInputTraits.isSecureTextEntry
		keyboardAppearance = textInputTraits.keyboardAppearance
		keyboardType = textInputTraits.keyboardType
		passwordRules = textInputTraits.passwordRules
		returnKeyType = textInputTraits.returnKeyType
		smartDashesType = textInputTraits.smartDashesType
		smartInsertDeleteType = textInputTraits.smartInsertDeleteType
		smartQuotesType = textInputTraits.smartQuotesType
		spellCheckingType = textInputTraits.spellCheckingType
		textContentType = textInputTraits.textContentType
	}
}
