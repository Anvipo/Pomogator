//
//  Window.swift
//  Pomogator
//
//  Created by Anvipo on 08.01.2023.
//

import UIKit

final class Window: UIWindow {
	weak var responderDelegate: UIResponderDelegate?

	override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		super.motionBegan(motion, with: event)
		switch motion {
		case .motionShake:
			responderDelegate?.shakeBegan()

		default:
			return
		}
	}

	override func motionEnded(
		_ motion: UIEvent.EventSubtype,
		with event: UIEvent?
	) {
		super.motionEnded(motion, with: event)
		switch motion {
		case .motionShake:
			responderDelegate?.shakeEnded()

		default:
			return
		}
	}
}
