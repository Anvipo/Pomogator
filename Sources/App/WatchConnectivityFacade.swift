//
//  WatchConnectivityFacade.swift
//  App
//
//  Created by Anvipo on 08.04.2023.
//

import WatchConnectivity

final class WatchConnectivityFacade: NSObject {
	private let wcSession: WCSession

	init(wcSession: WCSession) {
		self.wcSession = wcSession
	}
}

extension WatchConnectivityFacade {
	func start() {
		guard type(of: wcSession).isSupported() else {
			return
		}

		wcSession.delegate = self
		wcSession.activate()
	}
}

extension WatchConnectivityFacade {
	func send(mealTimeSchedule: PoedatorMealTimeSchedule) {
		guard wcSession.activationState == .activated,
			  wcSession.isWatchAppInstalled
		else {
			return
		}

		do {
			try wcSession.updateApplicationContext([.poedatorMealTimeScheduleKey: mealTimeSchedule])
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}
}

// swiftlint:disable unused_parameter
extension WatchConnectivityFacade: WCSessionDelegate {
	func session(_: WCSession, activationDidCompleteWith: WCSessionActivationState, error: Error?) {
		// no code
	}

	func sessionDidBecomeInactive(_: WCSession) {
		// no code
	}

	func sessionDidDeactivate(_: WCSession) {
		// no code
	}
}
// swiftlint:enable unused_parameter
