//
//  UIView.ConstraintMakeInfo.swift
//  Pomogator
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

// swiftlint:disable:next file_types_order
extension UIView {
	struct ConstraintMakeInfo {
		let relation: LayoutConstraintRelation

		var constant: CGFloat
	}
}

extension UIView.ConstraintMakeInfo {
	static func equal(constant: CGFloat = 0) -> Self {
		.init(relation: .equal, constant: constant)
	}

	static func lessThanOrEqual(constant: CGFloat = 0) -> Self {
		.init(relation: .lessThanOrEqual, constant: constant)
	}

	static func greaterThanOrEqual(constant: CGFloat = 0) -> Self {
		.init(relation: .greaterThanOrEqual, constant: constant)
	}
}

extension UIView.ConstraintMakeInfo {
	func constraint(
		firstAnchor: NSLayoutXAxisAnchor,
		secondAnchor: NSLayoutXAxisAnchor
	) -> NSLayoutConstraint {
		switch relation {
		case .lessThanOrEqual:
			return firstAnchor.constraint(
				lessThanOrEqualTo: secondAnchor,
				constant: constant
			)
			.apply { $0.identifier = "Pomogator lessThanOrEqual constraint" }

		case .equal:
			return firstAnchor.constraint(
				equalTo: secondAnchor,
				constant: constant
			)
			.apply { $0.identifier = "Pomogator equal constraint" }

		case .greaterThanOrEqual:
			return firstAnchor.constraint(
				greaterThanOrEqualTo: secondAnchor,
				constant: constant
			)
			.apply { $0.identifier = "Pomogator greaterThanOrEqual constraint" }
		}
	}

	func constraint(
		firstAnchor: NSLayoutYAxisAnchor,
		secondAnchor: NSLayoutYAxisAnchor
	) -> NSLayoutConstraint {
		switch relation {
		case .lessThanOrEqual:
			return firstAnchor.constraint(
				lessThanOrEqualTo: secondAnchor,
				constant: constant
			)
			.apply { $0.identifier = "Pomogator lessThanOrEqual constraint" }

		case .equal:
			return firstAnchor.constraint(
				equalTo: secondAnchor,
				constant: constant
			)
			.apply { $0.identifier = "Pomogator equal constraint" }

		case .greaterThanOrEqual:
			return firstAnchor.constraint(
				greaterThanOrEqualTo: secondAnchor,
				constant: constant
			)
			.apply { $0.identifier = "Pomogator greaterThanOrEqual constraint" }
		}
	}

	func constraint(
		firstAnchor: NSLayoutDimension,
		secondAnchor: NSLayoutDimension
	) -> NSLayoutConstraint {
		switch relation {
		case .lessThanOrEqual:
			return firstAnchor.constraint(
				lessThanOrEqualTo: secondAnchor,
				constant: constant
			)
			.apply { $0.identifier = "Pomogator lessThanOrEqual constraint" }

		case .equal:
			return firstAnchor.constraint(
				equalTo: secondAnchor,
				constant: constant
			)
			.apply { $0.identifier = "Pomogator equal constraint" }

		case .greaterThanOrEqual:
			return firstAnchor.constraint(
				greaterThanOrEqualTo: secondAnchor,
				constant: constant
			)
			.apply { $0.identifier = "Pomogator greaterThanOrEqual constraint" }
		}
	}
}

extension UIView.ConstraintMakeInfo: HasApplyChanges {}
