//
//  VychislyatorBodyMassIndexPresenter.swift
//  Pomogator
//
//  Created by Anvipo on 22.12.2022.
//
// swiftlint:disable file_length

import UIKit

final class VychislyatorBodyMassIndexPresenter: BasePresenter {
	private let assembly: VychislyatorBodyMassIndexAssembly
	private let bodyMassIndexCalculator: BodyMassIndexCalculator
	private let didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	private let didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator
	private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
	private let userDefaultsFacade: VychislyatorBodyMassIndexUserDefaultsFacade

	private var currentMassInKg: Decimal?
	private var currentHeightInCm: Decimal?
	private var currentBodyMassIndex: Decimal?

	private var parametersSection: VychislyatorBodyMassIndexSection?
	private var massInKgItem: StringFieldItem<VychislyatorBodyMassIndexItemIdentifier>?
	private var heightInCmItem: StringFieldItem<VychislyatorBodyMassIndexItemIdentifier>?

	private var resultSection: VychislyatorBodyMassIndexSection?

	private weak var view: VychislyatorBodyMassIndexVC?

	init(
		assembly: VychislyatorBodyMassIndexAssembly,
		bodyMassIndexCalculator: BodyMassIndexCalculator,
		coordinator: VychislyatorCoordinator,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator,
		currentMassInKg: Decimal?,
		currentHeightInCm: Decimal?,
		notificationFeedbackGenerator: UINotificationFeedbackGenerator,
		userDefaultsFacade: VychislyatorBodyMassIndexUserDefaultsFacade
	) {
		self.assembly = assembly
		self.bodyMassIndexCalculator = bodyMassIndexCalculator
		self.didTapBarButtonItemFeedbackGenerator = didTapBarButtonItemFeedbackGenerator
		self.didTapFieldViewFeedbackGenerator = didTapFieldViewFeedbackGenerator
		self.currentMassInKg = currentMassInKg
		self.currentHeightInCm = currentHeightInCm
		self.notificationFeedbackGenerator = notificationFeedbackGenerator
		self.userDefaultsFacade = userDefaultsFacade

		super.init(baseCoordinator: coordinator)
	}

	override func baseViewDidAppear() {
		super.baseViewDidAppear()
		didTapBarButtonItemFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.prepare()
	}
}

extension VychislyatorBodyMassIndexPresenter {
	func viewDidLoad() {
		let (
			massInKgItem,
			parametersSection
		) = assembly.initialParametersSection(
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator,
			currentMassInKg: currentMassInKg,
			massInKgItemDelegate: self
		)

		self.massInKgItem = massInKgItem
		self.parametersSection = parametersSection

		configureUI(changingItemID: nil)
	}

	func itemModel(
		by id: VychislyatorBodyMassIndexItemIdentifier,
		at indexPath: IndexPath
	) -> (any ReusableTableViewItem)? {
		guard let section = sectionModel(at: indexPath.section) else {
			return nil
		}

		return section.items.first { $0.id == id }?.base
	}

	func headerItemModel(at sectionIndex: Int) -> (any ReusableTableViewHeaderFooterItem)? {
		guard let section = sectionModel(at: sectionIndex) else {
			return nil
		}

		return section.headerItem
	}

	func didTapSaveButton() {
		assert(currentBodyMassIndex != nil)
		assert(currentHeightInCm != nil)
		assert(currentMassInKg != nil)

		userDefaultsFacade.bodyMassIndex = currentBodyMassIndex
		userDefaultsFacade.heightInCm = currentHeightInCm
		userDefaultsFacade.massInKg = currentMassInKg

		notificationFeedbackGenerator.notificationOccurred(.success)

		view?.hideSaveBodyMassIndexButton()
		view?.showDeleteSavedValuesButton()
	}

	func didTapDeleteSavedValues() {
		userDefaultsFacade.bodyMassIndex = nil
		userDefaultsFacade.heightInCm = nil
		userDefaultsFacade.massInKg = nil

		currentBodyMassIndex = nil
		currentHeightInCm = nil
		currentMassInKg = nil

		massInKgItem?.content.text = ""
		heightInCmItem = nil
		resultSection = nil

		parametersSection?.items = [massInKgItem?.eraseToAnyTableItem()].compactMap { $0 }

		let snapshotData = [
			parametersSection?.snapshotData,
			resultSection?.snapshotData
		].compactMap { $0 }
		view?.set(snapshotData: snapshotData)

		if let massInKgItem = self.massInKgItem {
			self.view?.reconfigure(items: [massInKgItem.id])
		} else {
			assertionFailure("?")
		}

		notificationFeedbackGenerator.notificationOccurred(.success)

		view?.hideSaveBodyMassIndexButton()
		view?.hideDeleteSavedValuesButton()
	}
}

extension VychislyatorBodyMassIndexPresenter: IRestorable {
	func saveUserActivityForRestore(to userActivity: NSUserActivity) {
		let restoreInfo = VychislyatorBodyMassIndexRestoreInfo(
			massInKg: currentMassInKg,
			heightInCm: currentHeightInCm
		)

		restoreInfo.save(into: userActivity)
	}

	func restore(from userActivity: NSUserActivity) {
		let restoreInfo = VychislyatorBodyMassIndexRestoreInfo(userActivity: userActivity)

		currentMassInKg = restoreInfo.massInKg
		currentHeightInCm = restoreInfo.heightInCm
	}
}

extension VychislyatorBodyMassIndexPresenter: StringFieldItemDelegate {
	func stringFieldItem<ID: IDType>(
		_ item: StringFieldItem<ID>,
		shouldChangeCharactersIn range: Range<String.Index>,
		replacementString: String
	) -> Bool {
		guard let itemID = item.id as? VychislyatorBodyMassIndexItemIdentifier else {
			assertionFailure("?")
			return false
		}

		let currentText = item.content.text
		let possibleString = currentText.replacingCharacters(in: range, with: replacementString)

		switch itemID {
		case .massInKg:
			if possibleString.isEmpty {
				return true
			}

			do {
				let currentMassInKg = try Decimal(possibleString, format: .number)
				return currentMassInKg < 1_000
			} catch {
				return false
			}

		case .heightInCm:
			if possibleString.isEmpty {
				return true
			}

			do {
				let inputedHeight = try Decimal(possibleString, format: .number)
				return inputedHeight < 1_000
			} catch {
				return false
			}

		default:
			assertionFailure("?")
			return true
		}
	}

	func stringFieldItemFormattedString<ID: IDType>(_ item: StringFieldItem<ID>) -> String {
		guard let itemID = item.id as? VychislyatorBodyMassIndexItemIdentifier else {
			assertionFailure("?")
			return ""
		}

		let currentText = item.content.text

		switch itemID {
		case .massInKg, .heightInCm:
			if currentText.isEmpty {
				return ""
			}

			do {
				let inputedDecimal = try Decimal(currentText, format: .number)
				return inputedDecimal.formatted(assembly.decimalFormatStyle)
			} catch {
				return ""
			}

		default:
			assertionFailure("?")
			return currentText
		}
	}

	func stringFieldItemDidChangeString<ID: IDType>(_ item: StringFieldItem<ID>) {
		guard let itemID = item.id as? VychislyatorBodyMassIndexItemIdentifier else {
			assertionFailure("?")
			return
		}

		let newText = item.content.text

		didTapBarButtonItemFeedbackGenerator.prepare()

		switch itemID {
		case .massInKg:
			massInKgItem?.content.text = newText

			if newText.isEmpty {
				currentMassInKg = nil
			} else {
				do {
					let currentMassInKg = try Decimal(newText, format: .number)
					if self.currentMassInKg == currentMassInKg {
						return
					}
					self.currentMassInKg = currentMassInKg
				} catch {
					assertionFailure(error.localizedDescription)
				}
			}

		case .heightInCm:
			heightInCmItem?.content.text = newText

			if newText.isEmpty {
				currentHeightInCm = nil
			} else {
				do {
					let currentHeightInCm = try Decimal(newText, format: .number)
					if self.currentHeightInCm == currentHeightInCm {
						return
					}
					self.currentHeightInCm = currentHeightInCm
				} catch {
					assertionFailure(error.localizedDescription)
				}
			}

		default:
			assertionFailure("?")
			return
		}

		configureUI(changingItemID: itemID)
	}
}

extension VychislyatorBodyMassIndexPresenter: FieldItemDelegate {
	func fieldItemDidBeginEditing<ID: IDType>(_ item: FieldItem<ID>) {
		guard item.id is VychislyatorBodyMassIndexItemIdentifier else {
			assertionFailure("?")
			return
		}

		didTapBarButtonItemFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.impactOccurred()
	}
}

extension VychislyatorBodyMassIndexPresenter {
	func set(view: VychislyatorBodyMassIndexVC) {
		self.view = view
	}
}

private extension VychislyatorBodyMassIndexPresenter {
	func sectionModel(at sectionIndex: Int) -> VychislyatorBodyMassIndexSection? {
		switch sectionIndex {
		case 0:
			return parametersSection

		case 1:
			return resultSection

		default:
			assertionFailure("?")
			return nil
		}
	}

	func configureUI(changingItemID: VychislyatorBodyMassIndexItemIdentifier?) {
		configureParametersSection(changingItemID: changingItemID)
		configureResultSection()

		let snapshotData = [
			parametersSection?.snapshotData,
			resultSection?.snapshotData
		].compactMap { $0 }

		view?.set(snapshotData: snapshotData)

		if currentBodyMassIndex != nil &&
		   currentBodyMassIndex != userDefaultsFacade.bodyMassIndex {
			view?.showSaveBodyMassIndexButton()
		} else {
			view?.hideSaveBodyMassIndexButton()
		}
	}

	func configureParametersSection(changingItemID: VychislyatorBodyMassIndexItemIdentifier?) {
		assert(parametersSection != nil)
		assert(massInKgItem != nil)

		defer {
			let items = [
				massInKgItem?.eraseToAnyTableItem(),
				heightInCmItem?.eraseToAnyTableItem()
			]

			parametersSection?.items = items.compactMap { $0 }
		}

		guard let changingItemID else {
			if currentMassInKg != nil && heightInCmItem == nil {
				setupHeightInCmItem()
			}

			let shouldHide = currentHeightInCm == nil && currentMassInKg == nil

			massInKgItem?.respondersNavigationFacade?.barButtonItems.forEach { $0.isHidden = shouldHide }

			return
		}

		switch changingItemID {
		case .massInKg:
			if currentMassInKg != nil && heightInCmItem == nil {
				// впервые ввели массу
				setupHeightInCmItem()
				massInKgItem?.respondersNavigationFacade?.barButtonItems.forEach { $0.isHidden = false }
			}

		case .heightInCm:
			break

		default:
			assertionFailure("?")
		}
	}

	func setupHeightInCmItem() {
		guard let massInKgItem else {
			assertionFailure("?")
			return
		}

		let heightInCmItem = assembly.heightInCmItem(
			delegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator,
			currentHeightInCm: currentHeightInCm
		)

		massInKgItem.respondersNavigationFacade?.nextResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			heightInCmItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		heightInCmItem.respondersNavigationFacade?.previousResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			massInKgItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		self.massInKgItem = massInKgItem
		self.heightInCmItem = heightInCmItem
	}

	func configureResultSection() {
		guard let massInKg = currentMassInKg,
			  let heightInCm = currentHeightInCm
		else {
			resultSection = nil
			return
		}

		let bodyMassIndex = bodyMassIndexCalculator.bodyMassIndex(massInKg: massInKg, heightInCm: heightInCm)

		if bodyMassIndex == currentBodyMassIndex {
			return
		}

		notificationFeedbackGenerator.prepare()

		currentBodyMassIndex = bodyMassIndex

		resultSection = assembly.resultSection(
			bodyMassIndexInfo: bodyMassIndexCalculator.bodyMassIndexInfo(from: bodyMassIndex)
		)
	}
}
