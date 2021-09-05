//
//  BaseTabBarController.swift
//  Pomogator
//
//  Created by Anvipo on 25.01.2023.
//

import UIKit

class BaseTabBarController: UITabBarController {
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
