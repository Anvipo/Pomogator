//
//  BasePageControlDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 05.01.2023.
//

@MainActor
protocol BasePageControlDelegate: AnyObject {
	func didTouch(pager: BasePageControl, index: Int)
}
