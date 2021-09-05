//
//  AppCoordinator.StartOption.swift
//  Pomogator
//
//  Created by Anvipo on 25.01.2023.
//

import Foundation

extension AppCoordinator {
	enum StartOption {
		case ordinaryLaunch
		case fromRestore(stateRestorationActivity: NSUserActivity)
		case fromSpotlight(searchableItemActivityIdentifier: String)
	}
}
