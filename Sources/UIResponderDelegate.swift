//
//  UIResponderDelegate.swift
//  Pomogator
//
//  Created by Anvipo on 08.01.2023.
//

import UIKit

@MainActor
protocol UIResponderDelegate: AnyObject {
	func shakeBegan()
	func shakeEnded()
}

extension UIResponderDelegate {
	func shakeBegan() {}
	func shakeEnded() {}
}
