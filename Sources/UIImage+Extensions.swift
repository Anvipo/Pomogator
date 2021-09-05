//
//  UIImage+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 07.01.2023.
//

import UIKit

extension UIImage {
	static func make(with color: UIColor, size: CGSize) -> UIImage {
		var size = size
		if size.width < 1 {
			size.width = 1
		}
		if size.height < 1 {
			size.height = 1
		}

		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		format.scale = 1

		let rect = CGRect(origin: .zero, size: size)

		return UIGraphicsImageRenderer(
			size: rect.size,
			format: format
		).image { context in
			color.setFill()
			context.cgContext.setFillColor(color.cgColor)
			context.cgContext.fill(rect)
		}
	}

	static func circle(
		diameter: CGFloat,
		color: UIColor,
		screen: UIScreen
	) -> UIImage {
		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		format.scale = 0

		return UIGraphicsImageRenderer(
			size: .init(side: diameter),
			format: format
		).image { context in
			context.cgContext.setFillColor(color.cgColor)

			let rect = CGRect(origin: .zero, size: .init(side: diameter))
			context.cgContext.fillEllipse(in: rect)
		}
	}

	static func rect(
		size: CGSize,
		color: UIColor,
		cornerRadius: CGFloat,
		forceRoundedRect: Bool
	) -> UIImage {
		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		format.scale = 0

		let width = max(1, size.width)
		let height = max(1, size.height)
		let rect = CGRect(x: 0, y: 0, width: width, height: height)

		return UIGraphicsImageRenderer(
			size: rect.size,
			format: format
		).image { context in
			if forceRoundedRect, cornerRadius > 0 {
				let layer = CALayer()
				layer.backgroundColor = color.cgColor
				layer.cornerRadius = cornerRadius
				layer.frame = rect
				layer.masksToBounds = true
				layer.render(in: context.cgContext)
			} else {
				let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
				color.setFill()
				path.fill()
			}
		}
	}

	static func oval(size: CGSize, color: UIColor) -> UIImage {
		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		format.scale = 0

		let width = max(1, size.width)
		let height = max(1, size.height)
		let rect = CGRect(x: 0, y: 0, width: width, height: height)

		let image = UIGraphicsImageRenderer(
			size: rect.size,
			format: format
		).image { _ in
			color.setFill()
			UIBezierPath(ovalIn: rect).fill()
		}

		return image.resizableImage(withCapInsets: .init(horizontalInset: size.width / 2, verticalInset: size.height / 2))
	}
}

// MARK: - Repaint

extension UIImage {
	/// Изображение в черно-белом варианте
	var grayscaled: UIImage? {
		guard let currentFilter = CIFilter(name: "CIColorControls", parameters: [kCIInputSaturationKey: 0.nsNumberValue]) else {
			return nil
		}

		currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
		let context = CIContext(options: nil)
		guard let output = currentFilter.outputImage,
			  let cgImage = context.createCGImage(output, from: output.extent)
		else {
			return nil
		}

		return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
	}

	/// Инвертировать цвета изображения
	var withInvertedColors: UIImage {
		guard let inputImage = CIImage(image: self),
			  let filter = CIFilter(name: "CIColorInvert")
		else {
			return self
		}

		filter.setValue(inputImage, forKey: kCIInputImageKey)

		let context = CIContext()
		guard let ouptutImage = filter.outputImage,
			  let outputCgImage = context.createCGImage(ouptutImage, from: inputImage.extent)
		else {
			return self
		}

		return UIImage(cgImage: outputCgImage)
	}

	func repainted(with color: UIColor) -> UIImage {
		let rect = CGRect(origin: .zero, size: size)

		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		format.scale = scale

		return UIGraphicsImageRenderer(
			size: rect.size,
			format: format
		).image { context in
			draw(in: rect)
			context.cgContext.setFillColor(color.cgColor)
			context.cgContext.setBlendMode(.sourceAtop)
			context.cgContext.fill(rect)
		}
	}

	func rotated(radians: CGFloat) -> UIImage {
		var newSize = CGRect(origin: .zero, size: size).applying(CGAffineTransform(rotationAngle: radians)).size
		// Trim off the extremely small float value to prevent core graphics from rounding it up
		newSize.width = floor(newSize.width)
		newSize.height = floor(newSize.height)

		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		format.scale = scale

		return UIGraphicsImageRenderer(
			size: newSize,
			format: format
		).image { context in
			// двигаем origin в центр
			context.cgContext.translateBy(x: newSize.width / 2, y: newSize.height / 2)
			// крутим вокруг центра
			context.cgContext.rotate(by: CGFloat(radians))
			// отрисовываем изображение в его центре
			draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
		}
	}

	func rounded(by radius: CGFloat) -> UIImage {
		let rect = CGRect(origin: .zero, size: size)

		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		format.scale = scale

		return UIGraphicsImageRenderer(
			size: rect.size,
			format: format
		).image { _ in
			let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
			path.addClip()

			draw(in: rect)
		}
	}

	func appliedBackground(with color: UIColor) -> UIImage {
		let rect = CGRect(origin: .zero, size: size)

		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		format.scale = scale

		return UIGraphicsImageRenderer(
			size: rect.size,
			format: format
		).image { context in
			context.cgContext.setFillColor(color.cgColor)
			context.cgContext.fill(rect)

			draw(at: .zero)
		}
	}

	/// Добавление фона изображению
	func appliedCircleBackground(with color: UIColor) -> UIImage {
		let rect = CGRect(origin: .zero, size: size)

		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		format.scale = scale

		return UIGraphicsImageRenderer(
			size: rect.size,
			format: format
		).image { context in
			context.cgContext.setFillColor(color.cgColor)
			context.cgContext.fillEllipse(in: rect)

			draw(at: .zero)
		}
	}

	func resized(to size: CGSize, screen: UIScreen) -> UIImage {
		if self.size == size {
			return self
		}

		let rect = CGRect(origin: .zero, size: size)

		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false

		return UIGraphicsImageRenderer(
			size: rect.size,
			format: format
		)
		.image { _ in
			draw(in: rect)
		}
		.withRenderingMode(renderingMode)
	}

	/// Уменьшить размер изображения по наибольшей стороне
	/// - Parameter imageSize: максимальное значение размера наибольшой стороны
	/// - Parameter useScreenScale: учитывать ли scale factor девайса
	func withDecreasedImageSize(to imageSize: CGFloat, useScreenScale: Bool) -> UIImage {
		let maxSize = max(size.width, size.height)
		let scaleFactor = imageSize / maxSize

		if scaleFactor >= 1 {
			return self
		}

		let width = Int(ceil(size.width * scaleFactor))
		let height = Int(ceil(size.height * scaleFactor))
		let newImageSize = CGSize(width: width, height: height)
		let newImageRect = CGRect(origin: .zero, size: newImageSize)

		let format = UIGraphicsImageRendererFormat(for: .current)
		format.opaque = false
		// scale = 1, для получения действительного размера изображения
		format.scale = useScreenScale ? 0 : 1

		return UIGraphicsImageRenderer(
			size: newImageSize,
			format: format
		).image { _ in
			draw(in: newImageRect)
		}
	}

	func applied(color: UIColor, blendMode: CGBlendMode) -> UIImage {
		UIGraphicsImageRenderer(size: size, format: .init(for: .current)).image { context in
			draw(at: .zero)

			color.setFill()
			context.fill(CGRect(origin: .zero, size: size), blendMode: blendMode)
		}
	}
}

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
