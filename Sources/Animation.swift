//
//  Animation.swift
//  Pomogator
//
//  Created by Anvipo on 02.01.2023.
//

enum Animation {
	case splashScreen
}

extension Animation {
	var name: String {
		switch self {
		case .splashScreen:
			return "SplashScreenAnimation"
		}
	}
}
