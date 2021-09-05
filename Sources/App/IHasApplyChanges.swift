//
//  IHasApplyChanges.swift
//  App
//
//  Created by Anvipo on 04.01.2023.
//

import UIKit

protocol IHasApplyChanges {}

extension IHasApplyChanges where Self: Any {
	func apply(changes change: (inout Self) throws -> Void) rethrows -> Self {
		var copy = self
		try change(&copy)
		return copy
	}
}

extension IHasApplyChanges where Self: AnyObject {
	func apply(changes change: (Self) throws -> Void) rethrows -> Self {
		try change(self)
		return self
	}
}

extension NSObject: IHasApplyChanges {}

extension CGPoint: IHasApplyChanges {}
extension CGRect: IHasApplyChanges {}
extension CGSize: IHasApplyChanges {}
extension CGVector: IHasApplyChanges {}

extension Array: IHasApplyChanges {}
extension Dictionary: IHasApplyChanges {}
extension Set: IHasApplyChanges {}
extension JSONDecoder: IHasApplyChanges {}
extension JSONEncoder: IHasApplyChanges {}

extension UIEdgeInsets: IHasApplyChanges {}
extension UIOffset: IHasApplyChanges {}
extension UIRectEdge: IHasApplyChanges {}

extension UIButton.Configuration: IHasApplyChanges {}
