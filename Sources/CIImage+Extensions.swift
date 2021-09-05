//
//  CIImage+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

import UIKit

struct Scale {
	let dx: CGFloat
	let dy: CGFloat
}

extension CIImage {
	func nonInterpolatedImage(
		withScale scale: Scale = Scale(dx: 1, dy: 1),
		opaque: Bool = true
	) -> UIImage? {
		guard let cgImage = CIContext(options: nil).createCGImage(self, from: extent) else {
			return nil
		}

		let size = CGSize(
			width: extent.size.width * scale.dx,
			height: extent.size.height * scale.dy
		)

		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = opaque
		format.scale = 0

		return UIGraphicsImageRenderer(size: size, format: format).image { context in
			context.cgContext.interpolationQuality = .none
			context.cgContext.translateBy(x: 0, y: size.height)
			context.cgContext.scaleBy(x: 1, y: -1)
			context.cgContext.draw(cgImage, in: context.cgContext.boundingBoxOfClipPath)
		}
	}
}
