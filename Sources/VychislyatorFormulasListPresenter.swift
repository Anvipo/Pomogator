//
//  VychislyatorFormulasListPresenter.swift
//  Pomogator
//
//  Created by Anvipo on 21.09.2021.
//

import UIKit

final class VychislyatorFormulasListPresenter: BasePresenter {
	private let assembly: VychislyatorFormulasListAssembly
	private let coordinator: VychislyatorCoordinator

	private var formulasSection: VychislyatorFormulasListSection?
	private weak var view: VychislyatorFormulasListVC?

	init(
		assembly: VychislyatorFormulasListAssembly,
		coordinator: VychislyatorCoordinator
	) {
		self.assembly = assembly
		self.coordinator = coordinator

		super.init(baseCoordinator: coordinator)
	}
}

extension VychislyatorFormulasListPresenter {
	func viewDidLoad() {
		guard let view else {
			assertionFailure("?")
			return
		}

		let formulasSection = assembly.formulasSection(
			onTapDailyCalorieIntakeButton: { [weak self] _ in
				self?.coordinator.showDailyCalorieIntakeFormulasScreen(animated: true)
			},
			onTapDailyCalorieIntakeAccessoryButton: { [weak self] accessoryButton in
				self?.coordinator.showPopover(
					text: String(localized: "Daily calorie intake hint"),
					on: accessoryButton
				)
			},
			onTapBodyMassIndexButtonButton: { [weak self] _ in
				self?.coordinator.showBodyMassIndexScreen(animated: true)
			},
			onTapBodyMassIndexButtonAccessoryButton: { [weak self] accessoryButton in
				self?.coordinator.showPopover(
					text: String(localized: "Body mass index hint"),
					on: accessoryButton
				)
			}
		)
		self.formulasSection = formulasSection

		view.set(snapshotData: [formulasSection.snapshotData])
	}

	func itemModel(
		by id: VychislyatorFormulasListItemIdentifier,
		at indexPath: IndexPath
	) -> (any ReusableTableViewItem)? {
		guard let section = sectionModel(at: indexPath.section) else {
			return nil
		}

		return section.items.first { $0.id == id }?.base
	}
}

extension VychislyatorFormulasListPresenter {
	func set(view: VychislyatorFormulasListVC) {
		self.view = view
	}
}

private extension VychislyatorFormulasListPresenter {
	func sectionModel(at sectionIndex: Int) -> VychislyatorFormulasListSection? {
		switch sectionIndex {
		case 0:
			return formulasSection

		default:
			assertionFailure("?")
			return nil
		}
	}
}
