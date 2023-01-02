//
//  PomogatorFaceVC.swift
//  Pomogator
//
//  Created by Anvipo on 08.01.2023.
//

import UIKit

final class PomogatorFaceVC: BaseVC {
	private lazy var imageView = UIImageView(image: Image.onboardingPomogatorHead.uiImage)

	override func loadView() {
		imageView.contentMode = .scaleAspectFill
		view = imageView
	}
}
