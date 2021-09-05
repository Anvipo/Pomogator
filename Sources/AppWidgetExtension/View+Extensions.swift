//
//  View+Extensions.swift
//  AppWidgetExtension
//
//  Created by Anvipo on 09.04.2023.
//

import SwiftUI
import WidgetKit

extension View {
	@ViewBuilder
	// swiftlint:disable:next function_default_parameter_at_end
	func widgetAccentableIfNeeded(_ accentable: Bool = true, widgetRenderingMode: WidgetRenderingMode) -> some View {
		if widgetRenderingMode == .accented {
			widgetAccentable(accentable)
		} else {
			self
		}
	}
}
