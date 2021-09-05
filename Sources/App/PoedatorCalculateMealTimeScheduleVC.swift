//
//  PoedatorCalculateMealTimeScheduleVC.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class PoedatorCalculateMealTimeScheduleVC: BaseTableVCWithSafeAreadButtons<
	PoedatorCalculateMealTimeScheduleSectionIdentifier,
	PoedatorCalculateMealTimeScheduleItemIdentifier
> {
	private let presenter: PoedatorCalculateMealTimeSchedulePresenter

	private lazy var fillButton = Button(
		fullConfiguration: Pomogator.filledButtonFullConfiguration(
			image: .listBulletClipboard,
			title: String(localized: "Fill with frequently used parameters button title")
		) { [weak presenter] _ in
			presenter?.didTapToFillWithFrequentlyUsedParametersButton()
		}
	)
	private lazy var saveButton = Button(
		fullConfiguration: Pomogator.filledButtonFullConfiguration(
			image: .save,
			title: String(localized: "Save calculated schedule button title")
		) { [weak presenter] _ in
			presenter?.didTapSaveButton()
		}
	)

	private weak var window: BaseWindow?

	init(
		presenter: PoedatorCalculateMealTimeSchedulePresenter,
		window: BaseWindow
	) {
		self.presenter = presenter
		self.window = window

		super.init(output: presenter)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
		presenter.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		presenter.viewDidAppear()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		presenter.viewDidDisappear()
	}

	override func handle(
		presses: Set<UIPress>,
		event: UIPressesEvent?,
		superImplementation: HandlePressesClosure
	) {
		guard presses.count == 1,
			  let press = presses.first
		else {
			assertionFailure("?")
			superImplementation(presses, event)
			return
		}

		guard let pressedKey = press.key else {
			superImplementation(presses, event)
			return
		}

		switch pressedKey.keyCode {
		case .keyboardEscape, .keyboardB:
			if press.phase == .ended && pressedKey.modifierFlags == .command {
				if presenter.isShowingPopover {
					presenter.passToPopover(presses: presses, event: event, superImplementation: superImplementation)
				}
			}

		case .keyboardS:
			if press.phase == .ended && pressedKey.modifierFlags == .command && !buttonsView.isHidden {
				presenter.didTapSaveButton()
			}

		case .keyboardA, .keyboardD:
			if press.phase == .ended && pressedKey.modifierFlags == .command {
				presenter.didTapAutoDeleteKey()
			}

		default:
			superImplementation(presses, event)
		}
	}

	override func accessibilityPerformMagicTap() -> Bool {
		guard !buttonsView.isHidden else {
			return false
		}

		presenter.didTapSaveButton()
		return true
	}

	deinit {
		Task { [weak window] in
			await window?.removeTapGestureRecognizerForHidingKeyboard()
		}
	}
}

extension PoedatorCalculateMealTimeScheduleVC {
	func set(saveButtonAccessibilityValue: String) {
		saveButton.accessibilityValue = saveButtonAccessibilityValue
	}

	func showFillWithFrequentlyUsedParametersButton() {
		show(button: fillButton)
	}

	func hideFillWithFrequentlyUsedParametersButton() {
		hide(button: fillButton)
	}

	func showSaveCalculatedMealTimeScheduleButton() {
		show(button: saveButton)
	}

	func hideSaveCalculatedMealTimeScheduleButton() {
		hide(button: saveButton)
	}

	func accessibilityNotificateAfterOutdatedScheduleAlert() {
		guard UIAccessibility.isVoiceOverRunning else {
			return
		}

		typealias LastMealTimeDateFieldView = DateFieldView<PoedatorCalculateMealTimeScheduleItemIdentifier>

		guard let lastMealTimeCell = cell(for: .lastMealTime),
			  let lastMealTimeDateFieldView: LastMealTimeDateFieldView = lastMealTimeCell.firstSubviewOfType()
		else {
			assertionFailure("?")
			return
		}

		UIAccessibility.post(notification: .layoutChanged, argument: lastMealTimeDateFieldView.contentView)
	}
}

private extension PoedatorCalculateMealTimeScheduleVC {
	func setUpUI() {
		if splitViewController == nil {
			setUpNCBackButton()
		}

		navigationItem.title = String(localized: "Calculate meal time schedule screen title")

		setUp(buttons: [fillButton, saveButton])

		hideSaveCalculatedMealTimeScheduleButton()
		hideFillWithFrequentlyUsedParametersButton()

		tableView.allowsSelection = false

		if ProcessInfo.processInfo.isiOSAppOnMac {
			return
		}

		window?.addTapGestureRecognizerForHidingKeyboard()
	}
}
