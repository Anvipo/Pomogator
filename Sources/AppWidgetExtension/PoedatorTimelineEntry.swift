//
//  PoedatorTimelineEntry.swift
//  AppWidgetExtension
//
//  Created by Anvipo on 09.03.2023.
//

import Foundation
import WidgetKit

struct PoedatorTimelineEntry: TimelineEntry {
	let date: Date

	let nextMealTime: Date?
}
