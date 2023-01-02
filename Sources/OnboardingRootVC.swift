//
//  OnboardingRootVC.swift
//  Pomogator
//
//  Created by Anvipo on 02.01.2023.
//

import UIKit

final class OnboardingRootVC: BaseVC {
	private let screen: UIScreen
	private let buttonSelectionFeedbackGenerator: UISelectionFeedbackGenerator
	private let pageControlSelectionFeedbackGenerator: UISelectionFeedbackGenerator
	private let completion: () -> Void

	private lazy var pomogatorFaceImageView = UIImageView(image: Image.onboardingPomogatorHead.uiImage)

	private lazy var swipeDownTextStackView = UIStackView()
	private lazy var swipeDownTextLabel = UILabel()

	private lazy var bottomLabel = UILabel()
	private lazy var pageControl = FluidPageControl(selectionFeedbackGenerator: pageControlSelectionFeedbackGenerator)
	private lazy var bottomStackView = UIStackView(arrangedSubviews: [bottomLabel, pageControl])
	private lazy var slideRightImageView = UIImageView(image: Image.chevronRight.uiImage)
	private lazy var onboardingScrollView = UIScrollView()
	private lazy var firstStepView = OnboardingOnlyTextStepView(
		text: "Добро пожаловать в\u{00a0}Помогатор!",
		screen: screen
	)
	private lazy var secondStepView = OnboardingOnlyTextStepView(
		text: "Помогатор создан для помощи в\u{00a0}поддержании здорового образа жизни",
		screen: screen
	)
	private lazy var thirdStepVC = OnboardingLastStepVC(models: [
		OnboardingLastStepItemView.Model(
			icon: .poedator,
			title: "Поедатор",
			text: "Составляет и запоминает расписание приёмов пищи на день"
		),
//		OnboardingLastStepItemView.Model(
//			icon: .xmarkCircleFill,
//			title: "Выпиватор",
//			text: "Составляет и запоминает расписание приёмов воды на день"
//		),
		OnboardingLastStepItemView.Model(
			icon: .vychislyator,
			title: "Вычислятор",
			text: "Вычисляет и запоминает необходимое количество каллорий и другие значения"
		),
		OnboardingLastStepItemView.Model(
			icon: .main,
			title: "Главная",
			text: "Отображает составленные расписания из каждого раздела приложения"
		)
	])
	private lazy var closeButton: Button = {
		var configuration = UIButton.Configuration.plain()
		configuration.image = Image.xmarkCircleFill.uiImage
		configuration.buttonSize = .large
		configuration.contentInsets = .zero

		return Button(
			fullConfiguration: .init(
				uiConfiguration: configuration,
				uiConfigurationUpdateHandler: nil
			) { [weak self] _ in
				self?.completion()
			}
		)
	}()

	private var pomogatorFaceSwipeGestureRecognizerShouldBegin: Bool

	private var pomogatorFaceImageViewTopConstraint: NSLayoutConstraint?
	private var pomogatorFaceImageViewBottomConstraint: NSLayoutConstraint?

	override var preferredStatusBarStyle: UIStatusBarStyle {
		.lightContent
	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		.portrait
	}

	init(
		screen: UIScreen,
		buttonSelectionFeedbackGenerator: UISelectionFeedbackGenerator,
		pageControlSelectionFeedbackGenerator: UISelectionFeedbackGenerator,
		completion: @escaping () -> Void
	) {
		self.screen = screen
		self.buttonSelectionFeedbackGenerator = buttonSelectionFeedbackGenerator
		self.pageControlSelectionFeedbackGenerator = pageControlSelectionFeedbackGenerator
		self.completion = completion

		pomogatorFaceSwipeGestureRecognizerShouldBegin = true

		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
}

extension OnboardingRootVC: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		pageControlSelectionFeedbackGenerator.prepare()

		let scrollTotalWidth = scrollView.contentSize.width - scrollView.bounds.width
		let scrollXOffset = scrollView.contentOffset.x
		let scrollXPercent = Double(scrollXOffset / scrollTotalWidth)

		let scrollProgress = scrollXPercent * Double(stepViews.lastElementIndex)
		pageControl.pageIndicatorProgress = scrollProgress

		pomogatorFaceSwipeGestureRecognizerShouldBegin = scrollProgress == 0

		let bottomLabelNewAlpha = 1 - scrollProgress
		bottomLabel.alpha = bottomLabelNewAlpha.normalize(min: 0, max: 1)

		let downedPomogatorFaceImageViewConstraintConstant = downedPomogatorFaceImageViewConstraintConstant
		let pomogatorFaceImageViewTopConstraintNewConstant: CGFloat
		if scrollProgress > Double(stepViews.penultimateElementIndex) {
			buttonSelectionFeedbackGenerator.prepare()

			let lastViewScrollXProgress = 1 - (Double(stepViews.lastElementIndex) - scrollProgress)

			let additionalScrolledDownValue = (view.frame.height - downedPomogatorFaceImageViewConstraintConstant) * lastViewScrollXProgress

			pomogatorFaceImageViewTopConstraintNewConstant = downedPomogatorFaceImageViewConstraintConstant + additionalScrolledDownValue

			slideRightImageView.alpha = CGFloat(stepViews.lastElementIndex) - CGFloat(scrollProgress)
			closeButton.alpha = lastViewScrollXProgress
		} else {
			pomogatorFaceImageViewTopConstraintNewConstant = downedPomogatorFaceImageViewConstraintConstant
			slideRightImageView.alpha = 1
			closeButton.alpha = 0
		}

		closeButton.isUserInteractionEnabled = closeButton.alpha == 1

		pomogatorFaceImageViewTopConstraint?.constant = pomogatorFaceImageViewTopConstraintNewConstant
	}
}

extension OnboardingRootVC: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		pomogatorFaceSwipeGestureRecognizerShouldBegin
	}
}

extension OnboardingRootVC: BasePageControlDelegate {
	func didTouch(pager: BasePageControl, index: Int) {
		if index > pager.currentPage + 1 {
			return
		}

		pageControlSelectionFeedbackGenerator.selectionChanged()

		onboardingScrollView.scrollRectToVisible(stepViews[index].frame, animated: true)
	}
}

private extension OnboardingRootVC {
	var stepViews: [UIView] {
		[firstStepView, secondStepView, thirdStepVC.view]
	}

	var downedPomogatorFaceImageViewConstraintConstant: CGFloat {
		bottomStackView.frame.minY - 150
	}

	@objc
	func didSwipeFace(_ gestureRecognizer: UISwipeGestureRecognizer) {
		guard let pomogatorFaceImageViewTopConstraint else {
			return
		}

		view.layoutIfNeeded()

		// swiftlint:disable vertical_parameter_alignment_on_call
		switch gestureRecognizer.direction {
		case .up:
			pomogatorFaceImageViewBottomConstraint?.isActive = true
			UIView.animate(
				withDuration: 1,
				delay: 0,
				usingSpringWithDamping: 1,
				initialSpringVelocity: 0,
				options: [.curveEaseInOut]
			) { [self] in
				pomogatorFaceImageViewTopConstraint.constant = 0
				view.layoutIfNeeded()

				bottomStackView.alpha = 0
				slideRightImageView.alpha = 0
				closeButton.alpha = 0
				swipeDownTextStackView.alpha = 1
			} completion: { [weak self] _ in
				self?.onboardingScrollView.isUserInteractionEnabled = false
			}

		case .down:
			pageControlSelectionFeedbackGenerator.prepare()

			pomogatorFaceImageViewBottomConstraint?.isActive = false
			UIView.animate(
				withDuration: 1,
				delay: 0,
				usingSpringWithDamping: 0.7,
				initialSpringVelocity: 0,
				options: [.curveEaseInOut]
			) { [self] in
				pomogatorFaceImageViewTopConstraint.constant = downedPomogatorFaceImageViewConstraintConstant
				view.layoutIfNeeded()

				bottomStackView.alpha = 1
				slideRightImageView.alpha = 1
				swipeDownTextStackView.alpha = 0
			} completion: { [weak self] _ in
				self?.onboardingScrollView.isUserInteractionEnabled = true
			}

		default:
			break
		}
		// swiftlint:enable multiline_arguments vertical_parameter_alignment_on_call
	}

	func setupSwipeDownStackView() {
		swipeDownTextLabel.text = "Свайпни вниз, чтобы начать"
		swipeDownTextLabel.numberOfLines = 0
		swipeDownTextLabel.textAlignment = .center
		swipeDownTextLabel.textColor = Color.black.uiColor
		swipeDownTextLabel.font = Font.callout.uiFont

		let swipeDownTextChevronDownImageView = UIImageView(image: Image.chevronDown.uiImage)
		swipeDownTextChevronDownImageView.tintColor = swipeDownTextLabel.textColor
		swipeDownTextChevronDownImageView.setContentHuggingPriority(.required, for: .horizontal)

		let swipeDownTextChevronDownImageView2 = UIImageView(image: Image.chevronDown.uiImage)
		swipeDownTextChevronDownImageView2.tintColor = swipeDownTextLabel.textColor
		swipeDownTextChevronDownImageView2.setContentHuggingPriority(.required, for: .horizontal)

		swipeDownTextStackView.addArrangedSubview(swipeDownTextChevronDownImageView)
		swipeDownTextStackView.addArrangedSubview(swipeDownTextLabel)
		swipeDownTextStackView.addArrangedSubview(swipeDownTextChevronDownImageView2)
	}

	func setupOnboardingScrollView() {
		onboardingScrollView.delegate = self
		onboardingScrollView.isUserInteractionEnabled = false
		onboardingScrollView.isPagingEnabled = true
		onboardingScrollView.showsHorizontalScrollIndicator = false
		onboardingScrollView.showsVerticalScrollIndicator = false

		onboardingScrollView.addSubviewsForConstraintsUse(stepViews)

		NSLayoutConstraint.activate(stepViews.makeSameAnchorConstraints(toHorizontalPagingScrollView: onboardingScrollView))
	}

	func setupBottomStackView() {
		pageControl.currentPage = 0
		pageControl.currentPageIndicatorTintColor = Color.brand.uiColor
		pageControl.delegate = self
		pageControl.numberOfPages = stepViews.count
		pageControl.pageIndicatorTintColor = Color.white.uiColor
		pageControl.pageIndicatorRadius = 9
		pageControl.pageIndicatorPadding = .defaultHorizontalOffset
		pageControl.pageIndicatorBorderWidth = 1
		pageControl.pageIndicatorBorderColor = Color.white.uiColor

		bottomLabel.text = "Прежде чем начать, ознакомьтесь с\u{00a0}функционалом приложения"
		bottomLabel.numberOfLines = 0
		bottomLabel.textAlignment = .center
		bottomLabel.font = Font.body.uiFont
		bottomLabel.textColor = Color.labelOnBrand.uiColor

		bottomStackView.alpha = 0
		bottomStackView.axis = .vertical
		bottomStackView.spacing = .defaultVerticalOffset
		bottomStackView.alignment = .center

		slideRightImageView.tintColor = Color.white.uiColor
		slideRightImageView.alpha = 0
	}

	func pomogatorFaceSwipeGestureRecognizer(
		direction: UISwipeGestureRecognizer.Direction
	) -> UISwipeGestureRecognizer {
		let recognizer = UISwipeGestureRecognizer(
			target: self,
			action: #selector(didSwipeFace(_:))
		)
		recognizer.direction = direction
		recognizer.delegate = self

		return recognizer
	}

	func setupPomogatorFaceImageView() {
		view.addGestureRecognizer(pomogatorFaceSwipeGestureRecognizer(direction: .up))
		view.addGestureRecognizer(pomogatorFaceSwipeGestureRecognizer(direction: .down))

		pomogatorFaceImageView.contentMode = .scaleAspectFill
	}

	// swiftlint:disable:next function_body_length
	func setupUI() {
		view.backgroundColor = Color.brand.uiColor

		closeButton.alpha = 0
		closeButton.tintColor = Color.white.uiColor

		setupPomogatorFaceImageView()
		setupOnboardingScrollView()
		setupSwipeDownStackView()
		setupBottomStackView()

		view.addSubviewsForConstraintsUse([
			onboardingScrollView,
			pomogatorFaceImageView,
			bottomStackView,
			slideRightImageView,
			swipeDownTextStackView,
			closeButton
		])

		let pomogatorFaceImageViewConstraintsWithInfo = pomogatorFaceImageView.makeSameAnchorConstraintsWithInfo(
			to: view,
			info: .edgesEqual()
		)
		pomogatorFaceImageViewTopConstraint = pomogatorFaceImageViewConstraintsWithInfo.top
		pomogatorFaceImageViewBottomConstraint = pomogatorFaceImageViewConstraintsWithInfo.bottom

		// чтобы увеличить область нажатия снизу у bottomStackView
		// (высота 0 - потому что bottomStackView.spacing уже итак == bottomInset)
		let spacerConfiguration = PlainSpacerItem(
			backgroundConfiguration: .clear(),
			id: UUID(),
			type: .vertical(0)
		)
		bottomStackView.addArrangedSubview(PlainSpacerView(item: spacerConfiguration))
		let bottomInset: CGFloat = .defaultVerticalOffset

		NSLayoutConstraint.activate(
			closeButton.makeSameAnchorConstraints(
				to: view.safeAreaLayoutGuide,
				info: .init(
					top: .equal(constant: .defaultVerticalOffset),
					trailing: .equal(constant: .defaultHorizontalOffset)
				)
			) +
			onboardingScrollView.makeSameAnchorConstraints(to: view.safeAreaLayoutGuide, info: .edgesEqual()) +
			pomogatorFaceImageViewConstraintsWithInfo.onlyConstraints +
			bottomStackView.makeSameAnchorConstraints(
				to: view.safeAreaLayoutGuide,
				info: .init(
					leading: .equal(constant: .defaultHorizontalOffset),
					bottom: .equal()
				)
			) +
			[bottomStackView.trailingAnchor.constraint(equalTo: slideRightImageView.leadingAnchor)] +
			slideRightImageView.makeSameAnchorConstraints(
				to: view.safeAreaLayoutGuide,
				info: .init(
					trailing: .equal(constant: .defaultHorizontalOffset),
					bottom: .equal(constant: bottomInset)
				)
			) +
			swipeDownTextStackView.makeSameAnchorConstraints(
				to: view.safeAreaLayoutGuide,
				info: .init(
					leading: .equal(constant: .defaultHorizontalOffset),
					trailing: .equal(constant: .defaultHorizontalOffset),
					bottom: .equal(constant: bottomInset)
				)
			)
		)
	}
}
