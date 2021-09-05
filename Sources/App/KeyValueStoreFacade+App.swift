//
//  KeyValueStoreFacade+App.swift
//  App
//
//  Created by Anvipo on 12.09.2021.
//

protocol IAppSettingsStoreFacade: AnyObject {
	var lastVersionPromptedForReview: String? { get set }
}

extension KeyValueStoreFacade {
	var lastVersionPromptedForReview: String? {
		get {
			value(forKey: .lastVersionPromptedForReviewKey, from: [.iCloud, .local])
		}
		set {
			set(value: newValue, forKey: .lastVersionPromptedForReviewKey, to: [.iCloud, .local])
		}
	}
}

private extension String {
	static var lastVersionPromptedForReviewKey: Self {
		"lastVersionPromptedForReview"
	}
}
