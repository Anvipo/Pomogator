//
//  UIImage+Extensions.swift
//  App
//
//  Created by Anvipo on 07.01.2023.
//

import UIKit

extension UIImage {
	func proportionallyResized(to newSize: CGSize) throws -> UIImage {
		let proportionallySize = try size.proportionallySized(basedOn: newSize)

		return redrawed(to: proportionallySize)
	}
}

private extension UIImage {
	func redrawed(to newSize: CGSize) -> UIImage {
		UIGraphicsImageRenderer(
			size: newSize,
			format: .init(for: .current)
		).image { _ in
			let rect = CGRect(origin: .zero, size: newSize)
			draw(in: rect)
		}
	}
}
