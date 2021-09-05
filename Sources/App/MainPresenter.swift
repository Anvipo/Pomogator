//
//  MainPresenter.swift
//  App
//
//  Created by Anvipo on 15.01.2023.
//

import UIKit
import WidgetKit

final class MainPresenter: BasePresenter {
	private let assembly: MainAssembly
	private let coordinator: MainCoordinator
	// swiftlint:disable:next weak_delegate
	private let labelItemPointerInteractionDelegate: UIPointerInteractionDelegate
	private let poedatorMealTimeScheduleStoreFacade: IPoedatorMealTimeScheduleStoreFacade
	private let widgetCenter: WidgetCenter

	private var savedMealTimeSchedule: PoedatorMealTimeSchedule
	private var poedatorSection: MainSection?
	private weak var view: MainVC?

	init(
		assembly: MainAssembly,
		coordinator: MainCoordinator,
		labelItemPointerInteractionDelegate: MainLabelItemPointerInteractionDelegate,
		poedatorMealTimeScheduleStoreFacade: IPoedatorMealTimeScheduleStoreFacade,
		widgetCenter: WidgetCenter
	) {
		self.assembly = assembly
		self.coordinator = coordinator
		self.labelItemPointerInteractionDelegate = labelItemPointerInteractionDelegate
		self.poedatorMealTimeScheduleStoreFacade = poedatorMealTimeScheduleStoreFacade
		self.widgetCenter = widgetCenter

		savedMealTimeSchedule = []
	}
}

extension MainPresenter {
	func viewDidLoad() {
		observeVoiceOverStatusDidChange { [weak self] in
			self?.configureUI(usingReloadData: true)
		}

		observeScheduleUpdates()
	}

	func viewWillAppear() {
		configureUI()
	}

	func sceneWillEnterForeground() {
		configureUI()
	}
}

extension MainPresenter: IBaseViewOutput {}

extension MainPresenter: IBaseTableViewOutput {
	func sectionModel(at sectionIndex: Int) -> MainSection? {
		if sectionIndex == 0 {
			return poedatorSection
		}

		fatalError("?")
	}

	// swiftlint:disable:next unused_parameter
	func didTapItem(with: MainItemIdentifier, at: IndexPath) {
		coordinator.prepareDidChangeScreenFeedbackGenerator()
		coordinator.goToPoedator()
	}
}

extension MainPresenter {
	func set(view: MainVC) {
		self.view = view
	}
}

private extension MainPresenter {
	func configureUI(usingReloadData: Bool = false) {
		let poedatorSection = makePoedatorSection()
		self.poedatorSection = poedatorSection

		let snapshotData = [
			poedatorSection.snapshotData
		]

		view?.set(
			snapshotData: snapshotData,
			usingReloadData: usingReloadData
		)
	}

	func makePoedatorSection() -> MainSection {
		savedMealTimeSchedule = poedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.iCloud, .sharedLocal])

		return assembly.poedatorSection(
			for: savedMealTimeSchedule,
			pointerInteractionDelegate: labelItemPointerInteractionDelegate
		)
	}

	func observeScheduleUpdates() {
		observeDidChangeExternallyNotification { [weak self] result in
			guard let self,
				  let notification = result.value,
				  notification.keys.contains(.poedatorMealTimeScheduleKey) else {
				return
			}

			self.handleChangedExternallySchedule()

			self.configureUI(usingReloadData: true)
		}
	}

	func handleChangedExternallySchedule() {
		let poedatorMealTimeSchedule = poedatorMealTimeScheduleStoreFacade.poedatorMealTimeSchedule(from: [.iCloud])
		poedatorMealTimeScheduleStoreFacade.save(poedatorMealTimeSchedule: poedatorMealTimeSchedule, to: [.sharedLocal])

		widgetCenter.reloadTimelines(ofKind: .poedatorAppWidgetKind)
	}
}
