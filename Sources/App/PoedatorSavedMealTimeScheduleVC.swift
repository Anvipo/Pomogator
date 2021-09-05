//
//  PoedatorSavedMealTimeScheduleVC.swift
//  App
//
//  Created by Anvipo on 05.09.2021.
//

import UIKit

final class PoedatorSavedMealTimeScheduleVC: BaseTableVCWithSafeAreadButtons<
	PoedatorSavedMealTimeScheduleSectionIdentifier,
	PoedatorSavedMealTimeScheduleItemIdentifier
> {
	private let presenter: PoedatorSavedMealTimeSchedulePresenter

	private lazy var addMealTimeRemindersButton = Button(
		fullConfiguration: Pomogator.filledButtonFullConfiguration(
			image: .bellFill,
			title: String(localized: "Add meal time notifications button title")
		) { [weak presenter] _ in
			presenter?.didTapAddRemindersButton()
		}
	).apply { addMealTimeRemindersButton in
		addMealTimeRemindersButton.accessibilityLabel = String(localized: "Add meal time notifications button accessibility label")
	}
	private lazy var changeMealTimeScheduleButton = Button(
		fullConfiguration: Pomogator.filledButtonFullConfiguration(
			image: .plus,
			title: String(localized: "Calculate meal time schedule button title")
		) { [weak presenter] _ in
			presenter?.didTapChangeMealTimeScheduleButton()
		}
	)
	private lazy var emptyView = EmptyView()
	private lazy var emptyViewWrapperView = emptyView.wrappedInVerticalScrollView()

	init(presenter: PoedatorSavedMealTimeSchedulePresenter) {
		self.presenter = presenter

		super.init(output: presenter)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpConstraints()
		setUpUI()
		presenter.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter.viewWillAppear()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		emptyView.viewDidLayoutSubviews(isSplitViewMode: isSplitViewMode)
		if isSplitViewMode {
			hide(button: changeMealTimeScheduleButton)
		} else {
			show(button: changeMealTimeScheduleButton)
		}

		setUpChangeMealTimeScheduleButtonTexts()
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
		case .keyboardC:
			if press.phase == .ended && pressedKey.modifierFlags == .command {
				presenter.didTapChangeMealTimeScheduleButton()
			}

		case .keyboardN:
			if press.phase == .ended && pressedKey.modifierFlags == .command {
				presenter.didTapAddRemindersButton()
			}

		case .keyboardDeleteOrBackspace, .keyboardD:
			if press.phase == .ended && pressedKey.modifierFlags == .command {
				presenter.didTapDeleteRemindersAndMealTimeScheduleButton()
			}

		default:
			superImplementation(presses, event)
		}
	}

	override func accessibilityPerformMagicTap() -> Bool {
		guard !changeMealTimeScheduleButton.isHidden else {
			return false
		}

		presenter.didTapChangeMealTimeScheduleButton()
		return true
	}

	override func shouldAdjustContentScrollViewBottomInset() -> Bool {
		true
	}

	override func contentScrollViewToAdjustBottomInset() -> UIScrollView {
		if isEmptyUIState {
			emptyViewWrapperView
		} else {
			tableView
		}
	}

	override func adjust(contentScrollView: UIScrollView, bottomInset: CGFloat, isButtonsViewVisible: Bool) {
		let additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)

		contentScrollView.animate(duration: isButtonsViewVisible ? defaultAnimationDuration : 0) { contentScrollView in
			contentScrollView.centerContentVerticallyIfNeeded(additionalSafeAreaInsets: additionalSafeAreaInsets)
		}
	}
}

extension PoedatorSavedMealTimeScheduleVC {
	func showEmptyStateUI(completion: ((_ isFinished: Bool) -> Void)?) {
		UIView.fadeTransition(
			from: tableView,
			to: emptyViewWrapperView,
			duration: defaultAnimationDuration,
			completion: completion
		)

		navigationItem.leftBarButtonItem?.isHidden = true

		setUpChangeMealTimeScheduleButtonTexts()
	}

	func showMealTimeScheduleUI() {
		UIView.fadeTransition(
			from: emptyViewWrapperView,
			to: tableView,
			duration: defaultAnimationDuration
		)

		navigationItem.leftBarButtonItem?.isHidden = false

		setUpChangeMealTimeScheduleButtonTexts()
	}

	func showAddMealTimeRemindersButton() {
		show(button: addMealTimeRemindersButton)
	}

	func hideAddMealTimeRemindersButton() {
		hide(button: addMealTimeRemindersButton)
	}

	func accessibilityNotificateAboutEmptyState() {
		guard UIAccessibility.isVoiceOverRunning else {
			return
		}

		UIAccessibility.post(notification: .layoutChanged, argument: emptyView)
	}

	func accessibilityNotificateAboutDidAddNotifications() {
		guard UIAccessibility.isVoiceOverRunning else {
			return
		}

		UIAccessibility.post(notification: .layoutChanged, argument: tableView.headerView(forSection: 0))
	}
}

private extension PoedatorSavedMealTimeScheduleVC {
	var isEmptyUIState: Bool {
		navigationItem.leftBarButtonItem?.isHidden == true
	}

	func setUpConstraints() {
		view.addSubviewsForConstraintsUse([emptyViewWrapperView])

		NSLayoutConstraint.activate(emptyViewWrapperView.makeEdgeConstraintsEqualToSuperviewSafeArea())
	}

	func setUpUI() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: Image.trash.uiImage,
			primaryAction: UIAction { [weak presenter] _ in
				presenter?.didTapDeleteRemindersAndMealTimeScheduleButton()
			}
		).apply { deleteRemindersAndMealTimeScheduleButton in
			deleteRemindersAndMealTimeScheduleButton.tintColor = .systemRed
			deleteRemindersAndMealTimeScheduleButton.accessibilityLabel = String(
				localized: "Delete saved meal time schedule alert accessibility label"
			)
		}
		navigationItem.title = String(localized: "Meal time schedule screen title")

		tableView.allowsSelection = false
		ignoreTableViewVisibilityInShouldAnimate = true

		setUp(buttons: [changeMealTimeScheduleButton, addMealTimeRemindersButton])
		hideAddMealTimeRemindersButton()

		observeSceneWillEnterForeground { [weak presenter] in
			presenter?.sceneWillEnterForeground()
		}
	}

	func setUpChangeMealTimeScheduleButtonTexts() {
		if isEmptyUIState {
			changeMealTimeScheduleButton.animate(duration: defaultAnimationDuration) { changeMealTimeScheduleButton in
				changeMealTimeScheduleButton.configuration?.title = String(localized: "Calculate meal time schedule button title")
				changeMealTimeScheduleButton.accessibilityLabel = String(localized: "Calculate meal time schedule button accessibility label")
				changeMealTimeScheduleButton.configuration?.image = Image.plus.uiImage
			}
		} else {
			changeMealTimeScheduleButton.animate(duration: defaultAnimationDuration) { changeMealTimeScheduleButton in
				changeMealTimeScheduleButton.configuration?.title = String(localized: "Change meal time schedule button title")
				changeMealTimeScheduleButton.accessibilityLabel = String(localized: "Change meal time schedule button accessibility label")
				changeMealTimeScheduleButton.configuration?.image = Image.pencil.uiImage
			}
		}
	}
}
