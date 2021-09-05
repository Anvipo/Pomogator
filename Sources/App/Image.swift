//
//  Image.swift
//  App
//
//  Created by Anvipo on 20.09.2021.
//

import UIKit

enum Image {
	case autoDelete

	case bellFill

	case chevronDown
	case chevronTrailing
	case chevronUp

	case firstMealTime

	case lastMealTime

	case listBulletClipboard

	case main

	case numberOfMealTimes

	case pencil
	case plus
	case poedator

	case questionmarkCircle

	case save

	case trash
}

extension Image {
	var uiImage: UIImage {
		let layoutDirection = UITraitCollection.current.layoutDirection

		let image: UIImage? =
		switch self {
		case .autoDelete: UIImage(named: "AutoDelete")
		case .bellFill: UIImage(systemName: "bell.fill")
		case .chevronDown: UIImage(systemName: "chevron.down")
		case .chevronTrailing:
			switch layoutDirection {
			case .leftToRight, .unspecified: UIImage(systemName: "chevron.right")
			case .rightToLeft: UIImage(systemName: "chevron.left")
			@unknown default: UIImage(systemName: "chevron.right")
			}
		case .chevronUp: UIImage(systemName: "chevron.up")
		case .firstMealTime: UIImage(named: "FirstMealTime")
		case .lastMealTime: UIImage(named: "LastMealTime")
		case .listBulletClipboard: UIImage(systemName: "list.bullet.clipboard")
		case .main: UIImage(named: "Main")
		case .numberOfMealTimes: UIImage(named: "NumberOfMealTimes")
		case .pencil: UIImage(systemName: "pencil")
		case .plus: UIImage(systemName: "plus")
		case .poedator: UIImage(named: "Poedator")
		case .questionmarkCircle: UIImage(systemName: "questionmark.circle")?.imageFlippedForRightToLeftLayoutDirection()
		case .save: UIImage(named: "Save")
		case .trash: UIImage(systemName: "trash")
		}

		if image == nil {
			assertionFailure("Для \(self) не найдена картинка")
		}

		return image ?? UIImage()
	}
}
