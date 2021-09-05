//
//  PopoverArrowDirection.swift
//  App
//
//  Created by Anvipo on 12.02.2023.
//

import UIKit

enum PopoverArrowDirection {
	case up
	case down
}

extension PopoverArrowDirection {
	var uiKitAnalog: UIPopoverArrowDirection {
		switch self {
		case .up: .up
		case .down: .down
		}
	}
}

extension Array where Element == PopoverArrowDirection {
	var uiKitAnalogs: UIPopoverArrowDirection {
		reduce(into: []) { partialResult, iteratingElement in
			partialResult.insert(iteratingElement.uiKitAnalog)
		}
	}
}
