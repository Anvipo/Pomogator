//
//  UIView.ConstraintMakeInfo.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//
// swiftlint:disable multiline_function_chains

import UIKit

extension UIView {
	struct ConstraintMakeInfo {
		var constant: CGFloat
		let priority: UILayoutPriority?
		let relation: LayoutConstraintRelation

		init(constant: CGFloat, relation: LayoutConstraintRelation, priority: UILayoutPriority? = nil) {
			self.constant = constant
			self.priority = priority
			self.relation = relation
		}
	}
}

extension UIView.ConstraintMakeInfo {
	static func equal(constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> Self {
		.init(constant: constant, relation: .equal, priority: priority)
	}
}

extension UIView.ConstraintMakeInfo {
	func makeConstraint(
		firstAnchor: NSLayoutXAxisAnchor,
		secondAnchor: NSLayoutXAxisAnchor
	) -> NSLayoutConstraint {
		switch relation {
		case .lessThanOrEqual:
			return firstAnchor.constraint(
				lessThanOrEqualTo: secondAnchor,
				constant: constant
			).apply { constraint in priority.flatMap { constraint.priority = $0 } }

		case .equal:
			return firstAnchor.constraint(
				equalTo: secondAnchor,
				constant: constant
			).apply { constraint in priority.flatMap { constraint.priority = $0 } }

		case .greaterThanOrEqual:
			return firstAnchor.constraint(
				greaterThanOrEqualTo: secondAnchor,
				constant: constant
			).apply { constraint in priority.flatMap { constraint.priority = $0 } }
		}
	}

	func makeConstraint(
		firstAnchor: NSLayoutYAxisAnchor,
		secondAnchor: NSLayoutYAxisAnchor
	) -> NSLayoutConstraint {
		switch relation {
		case .lessThanOrEqual:
			return firstAnchor.constraint(
				lessThanOrEqualTo: secondAnchor,
				constant: constant
			).apply { constraint in priority.flatMap { constraint.priority = $0 } }

		case .equal:
			return firstAnchor.constraint(
				equalTo: secondAnchor,
				constant: constant
			).apply { constraint in priority.flatMap { constraint.priority = $0 } }

		case .greaterThanOrEqual:
			return firstAnchor.constraint(
				greaterThanOrEqualTo: secondAnchor,
				constant: constant
			).apply { constraint in priority.flatMap { constraint.priority = $0 } }
		}
	}

	func makeConstraint(
		firstAnchor: NSLayoutDimension,
		secondAnchor: NSLayoutDimension
	) -> NSLayoutConstraint {
		switch relation {
		case .lessThanOrEqual:
			return firstAnchor.constraint(
				lessThanOrEqualTo: secondAnchor,
				constant: constant
			).apply { constraint in priority.flatMap { constraint.priority = $0 } }

		case .equal:
			return firstAnchor.constraint(
				equalTo: secondAnchor,
				constant: constant
			).apply { constraint in priority.flatMap { constraint.priority = $0 } }

		case .greaterThanOrEqual:
			return firstAnchor.constraint(
				greaterThanOrEqualTo: secondAnchor,
				constant: constant
			).apply { constraint in priority.flatMap { constraint.priority = $0 } }
		}
	}
}

extension UIView.ConstraintMakeInfo: IHasApplyChanges {}

// swiftlint:disable override_in_extension
extension NSLayoutConstraint {
	override open var debugDescription: String {
		var result = ""

		if let firstItem {
			result += _description(for: firstItem)
		}

		if firstAttribute != .notAnAttribute {
			result += ".\(firstAttribute._description)"
		}

		result += " \(relation._description)"

		if let secondItem {
			result += " \(_description(for: secondItem))"
		}

		if secondAttribute != .notAnAttribute {
			result += ".\(secondAttribute._description)"
		}

		if multiplier != 1 {
			result += " * \(multiplier)"
		}

		if secondAttribute == .notAnAttribute {
			result += " \(constant)"
		} else {
			if constant > 0 {
				result += " + \(constant)"
			} else if constant < 0.0 {
				result += " - \(abs(constant))"
			}
		}

		if priority.rawValue != 1_000 {
			result += " ^\(priority)"
		}

		result += " (isActive = \(isActive)"
		if let identifier {
			result += ", identifier = \(identifier)"
		}
		result += ")"

		return result
	}
}
// swiftlint:enable override_in_extension

private extension NSLayoutConstraint.Attribute {
	var _description: String {
		switch self {
		case .notAnAttribute:       "notAnAttribute"
		case .top:                  "top"
		case .left:                 "left"
		case .bottom:               "bottom"
		case .right:                "right"
		case .leading:              "leading"
		case .trailing:             "trailing"
		case .width:                "width"
		case .height:               "height"
		case .centerX:              "centerX"
		case .centerY:              "centerY"
		case .lastBaseline:         "lastBaseline"
		case .firstBaseline:        "firstBaseline"
		case .topMargin:            "topMargin"
		case .leftMargin:           "leftMargin"
		case .bottomMargin:         "bottomMargin"
		case .rightMargin:          "rightMargin"
		case .leadingMargin:        "leadingMargin"
		case .trailingMargin:       "trailingMargin"
		case .centerXWithinMargins: "centerXWithinMargins"
		case .centerYWithinMargins: "centerYWithinMargins"
		@unknown default:			"unknown"
		}
	}
}

private extension NSLayoutConstraint.Relation {
	var _description: String {
		switch self {
		case .equal:              "=="
		case .greaterThanOrEqual: ">="
		case .lessThanOrEqual:    "<="
		@unknown default:		  "unknown"
		}
	}
}

private func _description(for object: AnyObject) -> String {
	let objectDescription = object.debugDescription ?? ""
	let pointerDescription = String(format: "%p", UInt(bitPattern: ObjectIdentifier(object)))

	return "(\(objectDescription): \(pointerDescription))"
}
