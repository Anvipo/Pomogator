//
//  BaseViewOutput.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import UIKit

@MainActor
protocol BaseViewOutput: AnyObject {
	func baseViewDidAppear()
	func didTapBackButton(poppedVC: UIViewController?)
	func didReceiveMemoryWarning()
}
