//
//  PoedatorWidget.swift
//  AppWidgetExtension
//
//  Created by Anvipo on 09.03.2023.
//

import SwiftUI
import WidgetKit

struct PoedatorWidget {
	private let dependenciesStorage: DependenciesStorage

	init() {
		dependenciesStorage = .shared
	}
}

extension PoedatorWidget: Widget {
	var body: some WidgetConfiguration {
		StaticConfiguration(
			kind: .poedatorAppWidgetKind,
			provider: PoedatorTimelineProvider(sharedPoedatorMealTimeScheduleStoreFacade: dependenciesStorage.keyValueStoreFacade),
			content: { entry in
				PoedatorWidgetView(
					calendar: dependenciesStorage.calendar,
					entry: entry,
					mealTimeSchedule: dependenciesStorage.keyValueStoreFacade.poedatorMealTimeSchedule(from: [.sharedLocal])
				)
				.foregroundStyle(Color.labelOnBrand)
				.widgetBackground(Color.brand)
			}
		)
		.configurationDisplayName(String(localized: "Poedator display name"))
		.description(String(localized: "Poedator description"))
		.supportedFamilies([.systemSmall] + WidgetFamily.accessories)
	}
}

private extension View {
	func widgetBackground(_ backgroundView: some View) -> some View {
		if #available(iOSApplicationExtension 17, *) {
			return containerBackground(for: .widget) {
				backgroundView
			}
		}

		return ZStack {
			backgroundView

			self.padding()
		}
	}
}
