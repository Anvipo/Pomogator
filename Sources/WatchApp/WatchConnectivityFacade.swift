//
//  WatchConnectivityFacade.swift
//  WatchApp
//
//  Created by Anvipo on 08.04.2023.
//

import WatchConnectivity
import WidgetKit

final class WatchConnectivityFacade: NSObject, ObservableObject {
	private let keyValueStoreFacade: ISharedPoedatorMealTimeScheduleStoreFacade
	private let wcSession: WCSession
	private let widgetCenter: WidgetCenter

	@Published var poedatorMealTimeSchedule: PoedatorMealTimeSchedule

	init(
		keyValueStoreFacade: ISharedPoedatorMealTimeScheduleStoreFacade,
		wcSession: WCSession,
		widgetCenter: WidgetCenter
	) {
		self.keyValueStoreFacade = keyValueStoreFacade
		self.wcSession = wcSession
		self.widgetCenter = widgetCenter

		poedatorMealTimeSchedule = []
	}
}

extension WatchConnectivityFacade {
	func start() {
		guard type(of: wcSession).isSupported() else {
			return
		}

		wcSession.delegate = self
		wcSession.activate()

		handle(applicationContext: wcSession.receivedApplicationContext)
	}
}

extension WatchConnectivityFacade: WCSessionDelegate {
	func session(
		_ session: WCSession,
		activationDidCompleteWith activationState: WCSessionActivationState,
		// swiftlint:disable:next unused_parameter
		error: Error?
	) {
		guard activationState == .activated else {
			return
		}

		let applicationContext = session.receivedApplicationContext

		handle(applicationContext: applicationContext)
	}

	func session(_: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
		handle(applicationContext: applicationContext)
	}
}

private extension WatchConnectivityFacade {
	func handle(applicationContext: [String: Any]) {
		if applicationContext.isEmpty {
			return
		}

		guard let poedatorMealTimeSchedule = applicationContext.poedatorMealTimeSchedule,
			  self.poedatorMealTimeSchedule != poedatorMealTimeSchedule
		else {
			return
		}

		keyValueStoreFacade.save(poedatorMealTimeSchedule: poedatorMealTimeSchedule, to: [.sharedLocal])

		DispatchQueue.main.async {
			self.poedatorMealTimeSchedule = poedatorMealTimeSchedule
		}

		widgetCenter.reloadTimelines(ofKind: .poedatorWatchAppWidgetKind)
	}
}

private extension Dictionary where Key == String {
	var poedatorMealTimeSchedule: PoedatorMealTimeSchedule? {
		self[.poedatorMealTimeScheduleKey] as? PoedatorMealTimeSchedule
	}
}
