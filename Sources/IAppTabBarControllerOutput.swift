//
//  IAppTabBarControllerOutput.swift
//  Pomogator
//
//  Created by Anvipo on 25.01.2023.
//

protocol IAppTabBarControllerOutput: AnyObject {
	func didChangeTabIndex(to newValue: Int)
}
