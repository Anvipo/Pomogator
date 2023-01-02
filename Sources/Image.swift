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

	case figureCooldown
	case figureDressLineVerticalFigure
	case firstMealTime

	case lastMealTime

	case main

	case numberOfMealTimes

	case onboardingPomogatorHead

	case pencil
	case personTextRectangle
	case plus
	case poedator

	case questionmarkCircle

	case rulerFigure

	case scaleMass

	case trash

	case vychislyator
	case xmarkCircleFill
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

		case .figureCooldown:
			image = UIImage(systemName: "figure.cooldown")

		case .figureDressLineVerticalFigure:
			image = UIImage(named: "FigureDressLineVerticalFigure")

		case .firstMealTime:
			image = UIImage(named: "FirstMealTime")

		case .lastMealTime:
			image = UIImage(named: "LastMealTime")

		case .main:
			image = UIImage(named: "Main")

		case .numberOfMealTimes:
			image = UIImage(named: "NumberOfMealTimes")

		case .onboardingPomogatorHead:
			image = UIImage(named: "OnboardingPomogatorsHead")

		case .pencil:
			image = UIImage(systemName: "pencil")

		case .personTextRectangle:
			image = UIImage(systemName: "person.text.rectangle")

		case .plus:
			image = UIImage(systemName: "plus")

		case .poedator:
			image = UIImage(named: "Poedator")

		case .questionmarkCircle:
			image = UIImage(systemName: "questionmark.circle")

		case .rulerFigure:
			image = UIImage(named: "RulerFigure")

		case .scaleMass:
			image = UIImage(named: "ScaleMass")

		case .trash:
			image = UIImage(systemName: "trash")

		case .vychislyator:
			image = UIImage(named: "Vychislyator")

		case .xmarkCircleFill:
			image = UIImage(systemName: "xmark.circle.fill")
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
