//
//  PoedatorWidgetView.swift
//  AppWidgetExtension
//
//  Created by Anvipo on 09.03.2023.
//

import SwiftUI
import WidgetKit

struct PoedatorWidgetView {
	@Environment(\.widgetFamily) private var widgetFamily
	@Environment(\.widgetRenderingMode) private var widgetRenderingMode

	private let calendar: Calendar
	private let entry: PoedatorTimelineProvider.Entry
	private let mealTimeSchedule: PoedatorMealTimeSchedule

	init(
		calendar: Calendar,
		entry: PoedatorTimelineProvider.Entry,
		mealTimeSchedule: PoedatorMealTimeSchedule
	) {
		self.calendar = calendar
		self.entry = entry
		self.mealTimeSchedule = mealTimeSchedule
	}
}

extension PoedatorWidgetView: View {
	var body: some View {
		switch widgetFamily {
		case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge:
			smallContentView

		case .accessoryRectangular:
			smallContentView
				.widgetAccentableIfNeeded(widgetRenderingMode: widgetRenderingMode)

		case .accessoryInline:
			if let nextMealTime = entry.nextMealTime {
				Text(nextMealTimeTitle + " " + nextMealTimeText(nextMealTime: nextMealTime))
					.widgetAccentableIfNeeded(widgetRenderingMode: widgetRenderingMode)
			} else {
				noScheduleView
					.widgetAccentableIfNeeded(widgetRenderingMode: widgetRenderingMode)
			}

		case .accessoryCorner:
			accessoryCornerView

		case .accessoryCircular:
			accessoryCircularView
				.multilineTextAlignment(.center)
				.widgetAccentableIfNeeded(widgetRenderingMode: widgetRenderingMode)

		@unknown default:
			accessoryCircularView
				.widgetAccentableIfNeeded(widgetRenderingMode: widgetRenderingMode)
		}
	}
}

private extension PoedatorWidgetView {
	var noScheduleView: Text {
		let text = PoedatorTextManager.text(
			for: mealTimeSchedule,
			calendar: calendar
		)

		return Text(text)
	}

	var nextMealTimeTitle: String {
		widgetFamily.isAccessory
		? String(localized: "Poedator accessory title")
		: String(localized: "Poedator system small title")
	}

	@ViewBuilder
	var accessoryCircularView: some View {
		ZStack {
			AccessoryWidgetBackground()

			if let nextMealTime = entry.nextMealTime {
				Text(nextMealTimeText(nextMealTime: nextMealTime))
			} else {
				Text("--:--")
			}
		}
	}

	var accessoryCornerView: some View {
		let text: String
		if let nextMealTime = entry.nextMealTime {
			text = nextMealTimeText(nextMealTime: nextMealTime)
		} else {
			text = String(localized: "No saved meal time schedule accessory corner main text")
		}

		return EmptyView()
			.widgetLabel {
				Text(text)
					.widgetAccentableIfNeeded(widgetRenderingMode: widgetRenderingMode)
			}
			.widgetAccentableIfNeeded(widgetRenderingMode: widgetRenderingMode)
	}

	@ViewBuilder
	var smallContentView: some View {
		if let nextMealTime = entry.nextMealTime {
			let title = nextMealTimeTitle
			let text = nextMealTimeText(nextMealTime: nextMealTime)

			VStack {
				Text(title)
					.font(WidgetFont.caption.font)
					.multilineTextAlignment(.center)

				Text(text)
					.font(WidgetFont.title.font)
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel(Text(title))
			.accessibilityValue(Text(text))
		} else {
			noScheduleView
				.font(WidgetFont.caption.font)
				.multilineTextAlignment(.center)
		}
	}

	func nextMealTimeText(nextMealTime: Date) -> String {
		PoedatorTextManager.format(mealTime: nextMealTime, addDayAndMonth: false)
	}
}
