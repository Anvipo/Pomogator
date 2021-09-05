//
//  HasApplyChanges.swift
//  Pomogator
//
//  Created by Anvipo on 04.01.2023.
//

import UIKit

protocol HasApplyChanges {}

extension HasApplyChanges where Self: Any {
	func apply(changes change: (inout Self) throws -> Void) rethrows -> Self {
		var copy = self
		try change(&copy)
		return copy
	}
}

extension HasApplyChanges where Self: AnyObject {
	func apply(changes change: (Self) throws -> Void) rethrows -> Self {
		try change(self)
		return self
	}
}

extension NSObject: HasApplyChanges {}

extension CGPoint: HasApplyChanges {}
extension CGRect: HasApplyChanges {}
extension CGSize: HasApplyChanges {}
extension CGVector: HasApplyChanges {}

extension Array: HasApplyChanges {}
extension Dictionary: HasApplyChanges {}
extension Set: HasApplyChanges {}
extension JSONDecoder: HasApplyChanges {}
extension JSONEncoder: HasApplyChanges {}

extension UIEdgeInsets: HasApplyChanges {}
extension UIOffset: HasApplyChanges {}
extension UIRectEdge: HasApplyChanges {}

extension UIButton.Configuration: HasApplyChanges {}
