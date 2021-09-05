//
//  Image.swift
//  Pomogator
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

enum Image {
	case chevronDown
	case chevronRight
	case chevronUp

	case firstMealTime

	case lastMealTime

	case main

	case numberOfMealTimes

	case pencil
	case plus
	case poedator

	case trash
}

extension Image {
	var uiImage: UIImage {
		let image: UIImage?
		switch self {
		case .chevronDown:
			image = UIImage(systemName: "chevron.down")

		case .chevronRight:
			image = UIImage(systemName: "chevron.right")

		case .chevronUp:
			image = UIImage(systemName: "chevron.up")

		case .firstMealTime:
			image = UIImage(named: "FirstMealTime")

		case .lastMealTime:
			image = UIImage(named: "LastMealTime")

		case .main:
			image = UIImage(named: "Main")

		case .numberOfMealTimes:
			image = UIImage(named: "NumberOfMealTimes")

		case .pencil:
			image = UIImage(systemName: "pencil")

		case .plus:
			image = UIImage(systemName: "plus")

		case .poedator:
			image = UIImage(named: "Poedator")

		case .trash:
			image = UIImage(systemName: "trash")
		}

		if image == nil {
			assertionFailure("Для \(self) не найдена картинка")
		}

		return image ?? UIImage()
	}

	func proportionallyResizedImage(to newSize: CGSize) throws -> UIImage {
		try uiImage.proportionallyResized(to: newSize)
	}
}
