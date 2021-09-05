//
//  CGSize+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 29.08.2021.
//

import CoreGraphics

extension CGSize {
	static func - (lhs: Self, rhs: Self) -> Self {
		Self(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
	}
}

extension CGSize {
	var hasAtLeastOneZeroSide: Bool {
		self == .zero || width == 0 || height == 0
	}

	init(side: CGFloat) {
		self.init(width: side, height: side)
	}

	func proportionallySized(basedOn targetSize: Self) throws -> Self {
		if hasAtLeastOneZeroSide {
			let error = ProportionallySizingError.hasAtLeastOneZeroSide
			assertionFailure(error.localizedDescription)
			throw error
		}

		let widthRatio = targetSize.width / width
		let heightRatio = targetSize.height / height

		let neededRatio = min(widthRatio, heightRatio)
		return scaled(ratio: neededRatio)
	}
}

extension CGSize {
	/// Возвращает длину большей меры размера.
	///
	/// Если ширина больше высоты, то вернётся ширина.
	/// Иначе — высота.
	var largerMeasure: CGFloat {
		max(width, height)
	}

	/// соотношение высоты к ширине
	var heightToWidthRatio: CGFloat {
		height / width
	}

	/// соотношение ширины к высоте
	var widthToHeightRatio: CGFloat {
		width / height
	}

	/// получение точки с округлением
	var rounded: Self {
		Self(width: ceil(width), height: ceil(height))
	}

	/// Получение размера с изменением маштаба
	func scaled(ratio: CGFloat) -> Self {
		Self(width: width * ratio, height: height * ratio)
	}
}

extension CGSize: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(width, height)
	}
}
