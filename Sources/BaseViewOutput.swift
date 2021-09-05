//
//  BaseViewOutput.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

@MainActor
protocol BaseViewOutput: AnyObject {
	func baseViewDidAppear()
	func didTapBackButton()
}
