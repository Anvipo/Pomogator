//
//  VychislyatorDailyCalorieIntakeFormulasListPresenter.swift
//  Pomogator
//
//  Created by Anvipo on 26.09.2021.
//
// swiftlint:disable file_length

import UIKit

final class VychislyatorDailyCalorieIntakeFormulasListPresenter: BasePresenter {
	private let assembly: VychislyatorDailyCalorieIntakeFormulasListAssembly
	private let didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	private let didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator
	private let mifflinStJeorCalculator: MifflinStJeorCalculator
	private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
	private let userDefaultsFacade: VychislyatorDailyCalorieIntakeUserDefaultsFacade

	private let personSexes: [PersonSex]
	private let physicalActivities: [PhysicalActivity]

	private var selectedPersonSex: PersonSex
	private var inputedAgeInYears: UInt?
	private var inputedHeightInCm: Decimal?
	private var inputedMassInKg: Decimal?
	private var selectedPhysicalActivity: PhysicalActivity

	private var parametersSection: VychislyatorDailyCalorieIntakeFormulasListSection?
	private var personSexItem: PersonSexPickerFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier>?
	private var ageInYearsItem: StringFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier>?
	private var heightInCmItem: StringFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier>?
	private var massInKgItem: StringFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier>?
	private var physicalActivityItem: PhysicalActivityPickerFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier>?

	private var currentMifflinStJeorKcNormalValue: Decimal?

	private var mifflinStJeorSection: VychislyatorDailyCalorieIntakeFormulasListSection?
	private var basedOnMifflinStJeorSection: VychislyatorDailyCalorieIntakeFormulasListSection?

	private weak var view: VychislyatorDailyCalorieIntakeFormulasListVC?

	init(
		assembly: VychislyatorDailyCalorieIntakeFormulasListAssembly,
		coordinator: VychislyatorCoordinator,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		didTapFieldViewFeedbackGenerator: UIImpactFeedbackGenerator,
		mifflinStJeorCalculator: MifflinStJeorCalculator,
		notificationFeedbackGenerator: UINotificationFeedbackGenerator,
		userDefaultsFacade: VychislyatorDailyCalorieIntakeUserDefaultsFacade,

		personSexes: [PersonSex],
		selectedPersonSex: PersonSex,
		inputedAgeInYears: UInt?,
		inputedHeightInCm: Decimal?,
		inputedMassInKg: Decimal?,
		physicalActivities: [PhysicalActivity],
		selectedPhysicalActivity: PhysicalActivity
	) {
		self.assembly = assembly
		self.didTapBarButtonItemFeedbackGenerator = didTapBarButtonItemFeedbackGenerator
		self.didTapFieldViewFeedbackGenerator = didTapFieldViewFeedbackGenerator
		self.mifflinStJeorCalculator = mifflinStJeorCalculator
		self.notificationFeedbackGenerator = notificationFeedbackGenerator
		self.userDefaultsFacade = userDefaultsFacade

		self.personSexes = personSexes
		self.selectedPersonSex = selectedPersonSex
		self.inputedAgeInYears = inputedAgeInYears
		self.inputedHeightInCm = inputedHeightInCm
		self.inputedMassInKg = inputedMassInKg

		self.physicalActivities = physicalActivities
		self.selectedPhysicalActivity = selectedPhysicalActivity

		super.init(baseCoordinator: coordinator)
	}

	override func baseViewDidAppear() {
		super.baseViewDidAppear()
		didTapBarButtonItemFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.prepare()
	}
}

extension VychislyatorDailyCalorieIntakeFormulasListPresenter {
	func viewDidLoad() {
		let (
			personSexItem,
			ageInYearsItem,
			parametersSection
		) = assembly.initialParametersSection(
			inputedAgeInYears: inputedAgeInYears,
			personSexes: personSexes,
			selectedPersonSex: selectedPersonSex,
			personSexItemDelegate: self,
			ageInYearsItemDelegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		self.personSexItem = personSexItem
		self.ageInYearsItem = ageInYearsItem
		self.parametersSection = parametersSection

		configureUI(changingItemID: nil)
	}

	func itemModel(
		by id: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier,
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

	func footerItemModel(at sectionIndex: Int) -> (any ReusableTableViewHeaderFooterItem)? {
		guard let section = sectionModel(at: sectionIndex) else {
			return nil
		}

		return section.footerItem
	}

	func didTapSaveButton() {
		let selectedPersonSexIndex = personSexes.firstIndex(of: selectedPersonSex).flatMap(UInt.init(_:))
		let selectedPhysicalActivityIndex = physicalActivities.firstIndex(of: selectedPhysicalActivity).flatMap(UInt.init(_:))

		assert(selectedPersonSexIndex != nil)
		assert(inputedAgeInYears != nil)
		assert(inputedHeightInCm != nil)
		assert(inputedMassInKg != nil)
		assert(selectedPhysicalActivityIndex != nil)
		assert(currentMifflinStJeorKcNormalValue != nil)

		userDefaultsFacade.selectedPersonSexIndex = selectedPersonSexIndex
		userDefaultsFacade.ageInYears = inputedAgeInYears
		userDefaultsFacade.heightInCm = inputedHeightInCm
		userDefaultsFacade.massInKg = inputedMassInKg
		userDefaultsFacade.selectedPhysicalActivityIndex = selectedPhysicalActivityIndex
		userDefaultsFacade.mifflinStJeorKcNormalValue = currentMifflinStJeorKcNormalValue

		notificationFeedbackGenerator.notificationOccurred(.success)

		view?.hideSaveDailyCalorieIntakeButton()
		view?.showDeleteSavedValuesButton()
	}

	func didTapDeleteSavedValues() {
		userDefaultsFacade.selectedPersonSexIndex = nil
		userDefaultsFacade.ageInYears = nil
		userDefaultsFacade.heightInCm = nil
		userDefaultsFacade.massInKg = nil
		userDefaultsFacade.selectedPhysicalActivityIndex = nil
		userDefaultsFacade.mifflinStJeorKcNormalValue = nil

		selectedPersonSex = .male
		inputedAgeInYears = nil
		inputedHeightInCm = nil
		inputedMassInKg = nil
		selectedPhysicalActivity = .low
		currentMifflinStJeorKcNormalValue = nil

		personSexItem?.pickerFieldItem.selectedComponent.componentRowIndex = personSexes.firstIndex(of: selectedPersonSex) ?? 0
		ageInYearsItem?.content.text = ""
		heightInCmItem = nil
		massInKgItem = nil
		physicalActivityItem = nil
		mifflinStJeorSection = nil
		basedOnMifflinStJeorSection = nil

		parametersSection?.items = [
			personSexItem?.eraseToAnyTableItem(),
			ageInYearsItem?.eraseToAnyTableItem()
		].compactMap { $0 }

		let snapshotData = [
			parametersSection?.snapshotData,
			mifflinStJeorSection?.snapshotData,
			basedOnMifflinStJeorSection?.snapshotData
		].compactMap { $0 }
		view?.set(snapshotData: snapshotData)

		if let personSexItem, let ageInYearsItem {
			self.view?.reconfigure(items: [personSexItem.id, ageInYearsItem.id])
		} else {
			assertionFailure("?")
		}

		notificationFeedbackGenerator.notificationOccurred(.success)

		view?.hideSaveDailyCalorieIntakeButton()
		view?.hideDeleteSavedValuesButton()
	}
}

extension VychislyatorDailyCalorieIntakeFormulasListPresenter: IRestorable {
	func saveUserActivityForRestore(to userActivity: NSUserActivity) {
		let restoreInfo = VychislyatorDailyCalorieIntakeFormulasListRestoreInfo(
			personSex: selectedPersonSex,
			ageInYears: inputedAgeInYears,
			heightInCm: inputedHeightInCm,
			massInKg: inputedMassInKg,
			physicalActivity: selectedPhysicalActivity
		)

		restoreInfo.save(into: userActivity)
	}

	func restore(from userActivity: NSUserActivity) {
		let restoreInfo = VychislyatorDailyCalorieIntakeFormulasListRestoreInfo(userActivity: userActivity)

		selectedPersonSex = restoreInfo.personSex
		inputedAgeInYears = restoreInfo.ageInYears
		inputedHeightInCm = restoreInfo.heightInCm
		inputedMassInKg = restoreInfo.massInKg
		selectedPhysicalActivity = restoreInfo.physicalActivity
	}
}

extension VychislyatorDailyCalorieIntakeFormulasListPresenter: PickerFieldItemDelegate {
	func pickerFieldItemDidChangeComponent<ID: IDType>(_ item: PickerFieldItem<ID>) {
		guard let item = item as? PickerFieldItem<VychislyatorDailyCalorieIntakeFormulasListItemIdentifier> else {
			assertionFailure("?")
			return
		}

		let newComponent = item.selectedComponent

		didTapBarButtonItemFeedbackGenerator.prepare()

		switch item.id {
		case .personSex:
			assert(personSexItem != nil)
			selectedPersonSex = personSexes[newComponent.componentRowIndex]
			personSexItem?.pickerFieldItem.selectedComponent = newComponent

		case .physicalActivity:
			assert(physicalActivityItem != nil)
			selectedPhysicalActivity = physicalActivities[newComponent.componentRowIndex]
			physicalActivityItem?.pickerFieldItem.selectedComponent = newComponent

		default:
			assertionFailure("?")
			return
		}

		configureUI(changingItemID: item.id)
	}
}

extension VychislyatorDailyCalorieIntakeFormulasListPresenter: StringFieldItemDelegate {
	func stringFieldItem<ID: IDType>(
		_ item: StringFieldItem<ID>,
		shouldChangeCharactersIn range: Range<String.Index>,
		replacementString: String
	) -> Bool {
		guard let itemID = item.id as? VychislyatorDailyCalorieIntakeFormulasListItemIdentifier else {
			assertionFailure("?")
			return false
		}

		let currentText = item.content.text
		let possibleString = currentText.replacingCharacters(in: range, with: replacementString)

		switch itemID {
		case .ageInYears:
			if possibleString.isEmpty {
				return true
			}

			do {
				let inputedAge = try UInt(possibleString, format: .number)
				return inputedAge < 80
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

		case .massInKg:
			if possibleString.isEmpty {
				return true
			}

			do {
				let inputedMassInKg = try Decimal(possibleString, format: .number)
				return inputedMassInKg < 1_000
			} catch {
				return false
			}

		default:
			assertionFailure("?")
			return true
		}
	}

	func stringFieldItemFormattedString<ID: IDType>(_ item: StringFieldItem<ID>) -> String {
		guard let itemID = item.id as? VychislyatorDailyCalorieIntakeFormulasListItemIdentifier else {
			assertionFailure("?")
			return ""
		}

		let currentText = item.content.text

		switch itemID {
		case .ageInYears:
			if currentText.isEmpty {
				return ""
			}

			do {
				let inputedAge = try UInt(currentText, format: .number)
				return inputedAge.formatted(.number)
			} catch {
				return ""
			}

		case .heightInCm, .massInKg:
			if currentText.isEmpty {
				return ""
			}

			do {
				let inputedDecimal = try Decimal(currentText, format: .number)
				return inputedDecimal.formatted(.number)
			} catch {
				return ""
			}

		default:
			assertionFailure("?")
			return currentText
		}
	}

	// swiftlint:disable:next function_body_length
	func stringFieldItemDidChangeString<ID: IDType>(_ item: StringFieldItem<ID>) {
		guard let itemID = item.id as? VychislyatorDailyCalorieIntakeFormulasListItemIdentifier else {
			assertionFailure("?")
			return
		}

		let newText = item.content.text

		didTapBarButtonItemFeedbackGenerator.prepare()

		switch itemID {
		case .ageInYears:
			ageInYearsItem?.content.text = newText

			if newText.isEmpty {
				inputedAgeInYears = nil
			} else {
				do {
					let inputedAgeInYears = try UInt(newText, format: .number)
					if self.inputedAgeInYears == inputedAgeInYears {
						return
					}
					self.inputedAgeInYears = inputedAgeInYears
				} catch {
					assertionFailure(error.localizedDescription)
				}
			}

		case .heightInCm:
			heightInCmItem?.content.text = newText

			if newText.isEmpty {
				inputedHeightInCm = nil
			} else {
				do {
					let inputedHeightInCm = try Decimal(newText, format: .number)
					if self.inputedHeightInCm == inputedHeightInCm {
						return
					}
					self.inputedHeightInCm = inputedHeightInCm
				} catch {
					assertionFailure(error.localizedDescription)
				}
			}

		case .massInKg:
			massInKgItem?.content.text = newText

			if newText.isEmpty {
				inputedMassInKg = nil
			} else {
				do {
					let inputedMassInKg = try Decimal(newText, format: .number)
					if self.inputedMassInKg == inputedMassInKg {
						return
					}
					self.inputedMassInKg = inputedMassInKg
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

extension VychislyatorDailyCalorieIntakeFormulasListPresenter: FieldItemDelegate {
	func fieldItemDidBeginEditing<ID: IDType>(_ item: FieldItem<ID>) {
		guard item.id is VychislyatorDailyCalorieIntakeFormulasListItemIdentifier else {
			assertionFailure("?")
			return
		}

		didTapBarButtonItemFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.prepare()
		didTapFieldViewFeedbackGenerator.impactOccurred()
	}
}

extension VychislyatorDailyCalorieIntakeFormulasListPresenter {
	func set(view: VychislyatorDailyCalorieIntakeFormulasListVC) {
		self.view = view
	}
}

private extension VychislyatorDailyCalorieIntakeFormulasListPresenter {
	func sectionModel(at sectionIndex: Int) -> VychislyatorDailyCalorieIntakeFormulasListSection? {
		switch sectionIndex {
		case 0:
			return parametersSection

		case 1:
			return mifflinStJeorSection

		case 2:
			return basedOnMifflinStJeorSection

		default:
			assertionFailure("?")
			return nil
		}
	}

	func configureUI(changingItemID: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier?) {
		configureParametersSection(changingItemID: changingItemID)
		configureMifflinStJeorSection()

		let snapshotData = [
			parametersSection?.snapshotData,
			mifflinStJeorSection?.snapshotData,
			basedOnMifflinStJeorSection?.snapshotData
		].compactMap { $0 }

		view?.set(snapshotData: snapshotData)

		if currentMifflinStJeorKcNormalValue != nil &&
		   currentMifflinStJeorKcNormalValue != userDefaultsFacade.mifflinStJeorKcNormalValue {
			view?.showSaveDailyCalorieIntakeButton()
		} else {
			view?.hideSaveDailyCalorieIntakeButton()
		}
	}

	func configureParametersSection(changingItemID: VychislyatorDailyCalorieIntakeFormulasListItemIdentifier?) {
		assert(parametersSection != nil)
		assert(ageInYearsItem != nil)

		defer {
			let items = [
				personSexItem?.eraseToAnyTableItem(),
				ageInYearsItem?.eraseToAnyTableItem(),
				heightInCmItem?.eraseToAnyTableItem(),
				massInKgItem?.eraseToAnyTableItem(),
				physicalActivityItem?.eraseToAnyTableItem()
			]

			parametersSection?.items = items.compactMap { $0 }
		}

		guard let changingItemID else {
			if inputedAgeInYears != nil && heightInCmItem == nil {
				setupHeightInCmItem()
			}

			if inputedHeightInCm != nil && massInKgItem == nil {
				setupMassInKgItem()
			}

			if inputedMassInKg != nil && physicalActivityItem == nil {
				setupPhysicalActivityItem()
			}

			return
		}

		switch changingItemID {
		case .ageInYears:
			if inputedAgeInYears != nil && heightInCmItem == nil {
				// впервые ввели возраст
				setupHeightInCmItem()
			}

		case .heightInCm:
			if inputedHeightInCm != nil && massInKgItem == nil {
				// впервые ввели возраст
				setupMassInKgItem()
			}

		case .massInKg:
			if inputedMassInKg != nil && physicalActivityItem == nil {
				// впервые ввели массу
				setupPhysicalActivityItem()
			}

		default:
			break
		}
	}

	func configureMifflinStJeorSection() {
		guard let ageInYears = inputedAgeInYears,
			  let heightInCm = inputedHeightInCm,
			  let massInKg = inputedMassInKg
		else {
			mifflinStJeorSection = nil
			basedOnMifflinStJeorSection = nil
			return
		}

		let mifflinStJeorKcNormalValue = mifflinStJeorCalculator.kilocalories(
			massInKg: massInKg,
			heightInCm: heightInCm,
			ageInYears: Decimal(ageInYears),
			selectedPersonSex: selectedPersonSex,
			selectedPhysicalActivity: selectedPhysicalActivity
		)

		if currentMifflinStJeorKcNormalValue == mifflinStJeorKcNormalValue {
			return
		}

		currentMifflinStJeorKcNormalValue = mifflinStJeorKcNormalValue

		let massGainValue = mifflinStJeorKcNormalValue + (selectedPersonSex == .male ? "300".decimalFromEN : "250".decimalFromEN)
		let safeSlimmingValue = mifflinStJeorKcNormalValue - "250".decimalFromEN
		let fastSlimmingValue = mifflinStJeorKcNormalValue - "400".decimalFromEN

		let textForMassGainValue = mifflinStJeorCalculator.format(kilocalories: massGainValue, selectedPersonSex: selectedPersonSex)
		let textForNormalValue = mifflinStJeorCalculator.format(kilocalories: mifflinStJeorKcNormalValue, selectedPersonSex: selectedPersonSex)
		let textForSafeSlimmingValue = mifflinStJeorCalculator.format(kilocalories: safeSlimmingValue, selectedPersonSex: selectedPersonSex)
		let textForFastSlimmingValue = mifflinStJeorCalculator.format(kilocalories: fastSlimmingValue, selectedPersonSex: selectedPersonSex)

		mifflinStJeorSection = assembly.mifflinStJeorSection(
			titleForNormalValue: String(localized: "To save current mass"),
			textForNormalValue: textForNormalValue
		)

		basedOnMifflinStJeorSection = assembly.basedOnMifflinStJeorSection(
			titleForMassGainValue: String(localized: "To gain mass"),
			textForMassGainValue: textForMassGainValue,
			titleForSafeSlimmingValue: String(localized: "To lose mass in a safe way"),
			textForSafeSlimmingValue: textForSafeSlimmingValue,
			titleForFastSlimmingValue: String(localized: "To lose mass in a fast way"),
			textForFastSlimmingValue: textForFastSlimmingValue
		)
	}

	func setupHeightInCmItem() {
		guard let ageInYearsItem else {
			assertionFailure("?")
			return
		}

		let heightInCmItem = assembly.heightInCmItem(
			delegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator,
			inputedHeightInCm: inputedHeightInCm
		)

		ageInYearsItem.respondersNavigationFacade?.nextResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			heightInCmItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		heightInCmItem.respondersNavigationFacade?.previousResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			ageInYearsItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		self.ageInYearsItem = ageInYearsItem
		self.heightInCmItem = heightInCmItem
	}

	func setupMassInKgItem() {
		guard let heightInCmItem else {
			assertionFailure("?")
			return
		}

		let massInKgItem = assembly.massInKgItem(
			delegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator,
			inputedMassInKg: inputedMassInKg
		)

		heightInCmItem.respondersNavigationFacade?.nextResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			massInKgItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		massInKgItem.respondersNavigationFacade?.previousResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			heightInCmItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		self.heightInCmItem = heightInCmItem
		self.massInKgItem = massInKgItem
	}

	func setupPhysicalActivityItem() {
		guard let massInKgItem else {
			assertionFailure("?")
			return
		}

		let physicalActivityItem = assembly.physicalActivityItem(
			physicalActivities: physicalActivities,
			selectedPhysicalActivity: selectedPhysicalActivity,
			delegate: self,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		massInKgItem.respondersNavigationFacade?.nextResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			physicalActivityItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		physicalActivityItem.respondersNavigationFacade?.previousResponderNavigationHandler = { [weak self] in
			self?.didTapBarButtonItemFeedbackGenerator.impactOccurred()
			massInKgItem.currentResponderProvider.currentResponder?.becomeFirstResponder()
		}

		self.massInKgItem = massInKgItem
		self.physicalActivityItem = physicalActivityItem
	}
}
