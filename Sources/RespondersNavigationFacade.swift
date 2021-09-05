//
//  RespondersNavigationFacade.swift
//  Pomogator
//
//  Created by Anvipo on 24.11.2022.
//

import UIKit

final class RespondersNavigationFacade {
	var nextResponderNavigationHandler: (() -> Void)? {
		didSet {
			nextResponderNavigationBarButtonItem.isEnabled = nextResponderNavigationHandler != nil
		}
	}
	private lazy var nextResponderNavigationBarButtonItem: UIBarButtonItem = {
		UIBarButtonItem(
			primaryAction: UIAction(image: Image.chevronDown.uiImage) { [weak self] _ in
				self?.nextResponderNavigationHandler?()
			}
		)
	}()

	var previousResponderNavigationHandler: (() -> Void)? {
		didSet {
			previousResponderNavigationBarButtonItem.isEnabled = previousResponderNavigationHandler != nil
		}
	}
	private lazy var previousResponderNavigationBarButtonItem: UIBarButtonItem = {
		UIBarButtonItem(
			primaryAction: UIAction(image: Image.chevronUp.uiImage) { [weak self] _ in
				self?.previousResponderNavigationHandler?()
			}
		)
	}()

	init(
		nextResponderNavigationHandler: (() -> Void)? = nil,
		previousResponderNavigationHandler: (() -> Void)? = nil
	) {
		self.nextResponderNavigationHandler = nextResponderNavigationHandler
		self.previousResponderNavigationHandler = previousResponderNavigationHandler

		nextResponderNavigationBarButtonItem.isEnabled = nextResponderNavigationHandler != nil
		previousResponderNavigationBarButtonItem.isEnabled = previousResponderNavigationHandler != nil
	}
}

extension RespondersNavigationFacade {
	var barButtonItems: [UIBarButtonItem] {
		[previousResponderNavigationBarButtonItem, nextResponderNavigationBarButtonItem]
	}
}

extension RespondersNavigationFacade: Equatable {
	static func == (lhs: RespondersNavigationFacade, rhs: RespondersNavigationFacade) -> Bool {
		lhs.previousResponderNavigationBarButtonItem === rhs.previousResponderNavigationBarButtonItem &&
		lhs.nextResponderNavigationBarButtonItem === rhs.nextResponderNavigationBarButtonItem
	}
}
