//
//  MainLabelItemPointerInteractionDelegate.swift
//  App
//
//  Created by Anvipo on 12.02.2023.
//

import UIKit

final class MainLabelItemPointerInteractionDelegate: NSObject, UIPointerInteractionDelegate {
	// swiftlint:disable:next unused_parameter
	func pointerInteraction(_ interaction: UIPointerInteraction, styleFor: UIPointerRegion) -> UIPointerStyle? {
		guard let interactionView = interaction.view else {
			assertionFailure("?")
			return nil
		}

		let targetedPreview = UITargetedPreview(view: interactionView)
		return UIPointerStyle(effect: .hover(targetedPreview))
	}
}
