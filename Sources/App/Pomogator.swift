//
//  App.swift
//  App
//
//  Created by Anvipo on 12.09.2021.
//

import UIKit

enum Pomogator {}

extension Pomogator {
	static var fieldItemContentInsets: NSDirectionalEdgeInsets {
		.init(top: 14, leading: 16, bottom: 10, trailing: 16)
	}

	static func headerItem<ID: IDType>(
		content: PlainLabelHeaderItem<ID>.Content,
		id: ID,
		style: PlainLabelHeaderItemStyle = .extraProminentInsetGrouped,
		tintColorStyle: ColorStyle? = Self.defaultTintColorStyle
	) -> PlainLabelHeaderItem<ID> {
		PlainLabelHeaderItem(
			content: content,
			id: id,
			style: style,
			tintColorStyle: tintColorStyle
		)
	}

	static func footerItem<ID: IDType>(
		id: ID,
		text: String,
		style: PlainLabelFooterItemStyle = .grouped,
		textColorStyle: ColorStyle = .secondaryLabel,
		tintColorStyle: ColorStyle? = Self.defaultTintColorStyle
	) -> PlainLabelFooterItem<ID> {
		PlainLabelFooterItem(
			id: id,
			style: style,
			text: text,
			textProperties: PlainLabelFooterItem<ID>.makeTextProperties(style: style).apply { textProperties in
				textProperties.color = textColorStyle.color
			},
			tintColorStyle: tintColorStyle
		)
	}

	static func labelItem<ID: IDType>(
		content: PlainLabelItem<ID>.Content,
		id: ID,
		style: PlainLabelItemStyle,
		accessoryInfo: TableViewCellAccessoryInfo? = nil,
		accessibilityTraits: UIAccessibilityTraits = .staticText,
		backgroundColorHandler: ((UICellConfigurationState) -> UIColor)? = nil,
		pointerInteractionDelegate: UIPointerInteractionDelegate? = nil,
		textAlignment: UIListContentConfiguration.TextProperties.TextAlignment? = nil,
		textColorStyle: ColorStyle? = nil,
		textFontStyle: FontStyle? = nil,
		tintColorStyle: ColorStyle? = Self.defaultTintColorStyle
	) -> PlainLabelItem<ID> {
		PlainLabelItem(
			accessoryInfo: accessoryInfo,
			accessibilityTraits: accessibilityTraits,
			backgroundColorHandler: backgroundColorHandler,
			content: content,
			id: id,
			pointerInteractionDelegate: pointerInteractionDelegate,
			style: style,
			textProperties: PlainLabelItem<ID>.makeTextProperties().apply { textProperties in
				if let textAlignment {
					textProperties.alignment = textAlignment
				}
				if let textColorStyle {
					textProperties.color = textColorStyle.color
				}
				if let textFontStyle {
					textProperties.font = textFontStyle.font
				}
			},
			tintColorStyle: tintColorStyle
		)
	}

	static func switchFieldItem<ID: IDType>(
		accessoryButtonFullConfiguration: Button.FullConfiguration?,
		content: SwitchFieldItem<ID>.Content,
		delegate: ISwitchFieldItemDelegate,
		id: ID
	) -> SwitchFieldItem<ID> {
		SwitchFieldItem(
			content: content,
			delegate: delegate,
			fieldItem: fieldItem(
				accessoryButtonFullConfiguration: accessoryButtonFullConfiguration,
				delegate: delegate,
				id: id
			),
			onTintColorStyle: .brand,
			switchProvider: SwitchFieldItemSwitchProvider(),
			thumbTintColorStyle: .labelOnBrand
		)
	}

	static func infoAccessoryFullButtonConfiguration(
		accessibilityLabel: String,
		onTap: ((Button) -> Void)? = nil
	) -> Button.FullConfiguration {
		let uiConfiguration = UIButton.Configuration.plain().apply { configuration in
			configuration.image = Image.questionmarkCircle.uiImage
			configuration.buttonSize = .large
			configuration.preferredSymbolConfigurationForImage = .init(scale: .large)
			configuration.contentInsets = .zero
			configuration.baseForegroundColor = ColorStyle.brand.color
		}
		let uiConfigurationUpdateHandler: (Button) -> Void = { accessoryButton in
			accessoryButton.configuration?.baseForegroundColor = accessoryButton.isHighlighted
			? ColorStyle.brand.color.withBrightnessComponent(0.8)
			: ColorStyle.brand.color
		}

		return Button.FullConfiguration(
			accessibilityLabel: accessibilityLabel,
			adjustsImageSizeForAccessibilityContentSizeCategory: true,
			isPointerInteractionEnabled: true,
			uiConfiguration: uiConfiguration,
			uiConfigurationUpdateHandler: uiConfigurationUpdateHandler,
			onTap: onTap
		)
	}

	static func filledButtonFullConfiguration(
		image: Image?,
		title: String?,
		adjustsImageSizeForAccessibilityContentSizeCategory: Bool = true,
		isPointerInteractionEnabled: Bool = true,
		onTap: @escaping (Button) -> Void
	) -> Button.FullConfiguration {
		.init(
			accessibilityLabel: title,
			adjustsImageSizeForAccessibilityContentSizeCategory: adjustsImageSizeForAccessibilityContentSizeCategory,
			isPointerInteractionEnabled: isPointerInteractionEnabled,
			uiConfiguration: Pomogator.filledButtonConfiguration(
				image: image,
				title: title
			),
			uiConfigurationUpdateHandler: filledUIConfigurationUpdateHandler(button:),
			onTap: onTap
		)
	}

	static func stringFieldItem<ID: IDType>(
		content: StringFieldItem<ID>.Content,
		delegate: IStringFieldItemDelegate,
		id: ID,
		accessoryButtonFullConfiguration: Button.FullConfiguration? = nil,
		placeholder: String = String(localized: "Text field placeholder"),
		returnKeyType: UIReturnKeyType = .done,
		textKeyboardType: UIKeyboardType = .numberPad
	) -> StringFieldItem<ID> {
		StringFieldItem(
			content: content,
			delegate: delegate,
			textFieldItem: textFieldItem(
				delegate: delegate,
				fieldItem: fieldItem(
					accessoryButtonFullConfiguration: accessoryButtonFullConfiguration,
					delegate: delegate,
					id: id
				),
				placeholder: placeholder,
				textFieldInputTraits: Self.defaultTextFieldInputTraits.apply { textInputTraits in
					textInputTraits.returnKeyType = returnKeyType
				}
			),
			textKeyboardType: textKeyboardType
		)
	}

	static func dateFieldItem<ID: IDType>(
		content: DateFieldItem<ID>.Content,
		calendar: Calendar,
		delegate: IDateFieldItemDelegate,
		id: ID,
		accessoryButtonFullConfiguration: Button.FullConfiguration? = nil,
		placeholder: String = String(localized: "Text field placeholder"),
		returnKeyType: UIReturnKeyType = .done
	) -> DateFieldItem<ID> {
		DateFieldItem(
			calendar: calendar,
			content: content,
			datePickerMode: .dateAndTime,
			datePickerStyle: .wheels,
			datePickerTintColorStyle: Self.defaultTintColorStyle,
			delegate: delegate,
			textFieldItem: textFieldItem(
				delegate: delegate,
				fieldItem: fieldItem(
					accessoryButtonFullConfiguration: accessoryButtonFullConfiguration,
					delegate: delegate,
					id: id
				),
				placeholder: placeholder,
				textFieldInputTraits: Self.defaultTextFieldInputTraits.apply { textInputTraits in
					textInputTraits.returnKeyType = returnKeyType
					textInputTraits.textContentType = .dateTime
				},
				textFieldTintColorStyle: .clear
			),
			shouldEraseSeconds: true
		)
	}
}

extension Pomogator {
	static func configureToolbarItems<T: ITextFieldItemContainer>(
		in item: inout T,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) {
		let itemDoneToolbarItems = fieldViewDoneToolbarItems(
			doneRespondersFacade: item.respondersFacade,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		item.toolbarItems = item.toolbarNavigationItemsManager.barNavigationButtonItems + itemDoneToolbarItems
	}

	static func configureNextAndPreviousToolbarItems(
		previousItem: any ITextFieldItemContainer,
		previousResponderNavigationBarButtonItemAccessibilityLabel: String,
		nextItem: any ITextFieldItemContainer,
		nextResponderNavigationBarButtonItemAccessibilityLabel: String,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) {
		previousItem.respondersFacade.nextResponderProvider = {
			nextItem.respondersFacade.responderProvider?()
		}
		previousItem.toolbarNavigationItemsManager.nextResponderNavigationHandler = { [weak didTapBarButtonItemFeedbackGenerator] in
			didTapBarButtonItemFeedbackGenerator?.impactOccurred()

			previousItem.respondersFacade.nextResponderProvider!()?.becomeFirstResponder()
		}
		previousItem.toolbarNavigationItemsManager.set(
			nextResponderNavigationBarButtonItemAccessibilityLabel: nextResponderNavigationBarButtonItemAccessibilityLabel
		)

		nextItem.toolbarNavigationItemsManager.previousResponderNavigationHandler = { [weak didTapBarButtonItemFeedbackGenerator] in
			didTapBarButtonItemFeedbackGenerator?.impactOccurred()

			previousItem.respondersFacade.responderProvider?()?.becomeFirstResponder()
		}
		nextItem.respondersFacade.nextResponderProvider = {
			previousItem.respondersFacade.responderProvider?()
		}
		nextItem.toolbarNavigationItemsManager.set(
			previousResponderNavigationBarButtonItemAccessibilityLabel: previousResponderNavigationBarButtonItemAccessibilityLabel
		)
	}
}

private extension Pomogator {
	static var defaultTintColorStyle: ColorStyle {
		.brand
	}

	static var defaultTextFieldInputTraits: TextInputTraits {
		.`default`.apply { textInputTraits in
			textInputTraits.autocapitalizationType = .none
			textInputTraits.autocorrectionType = .no
			textInputTraits.smartDashesType = .no
			textInputTraits.smartInsertDeleteType = .no
			textInputTraits.smartQuotesType = .no
			textInputTraits.spellCheckingType = .no
		}
	}

	static func filledButtonConfiguration(
		image: Image? = nil,
		title: String? = nil
	) -> UIButton.Configuration {
		.filled().apply { configuration in
			configuration.background.backgroundColor = ColorStyle.brand.color
			configuration.buttonSize = .large
			configuration.image = image?.uiImage
			configuration.imagePadding = 8
			configuration.preferredSymbolConfigurationForImage = .init(scale: .large)
			configuration.title = title
			configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
				var outgoing = incoming
				outgoing.foregroundColor = ColorStyle.labelOnBrand.color
				return outgoing
			}
		}
	}

	static func fieldItem<ID: IDType>(
		accessoryButtonFullConfiguration: Button.FullConfiguration?,
		delegate: IFieldItemDelegate,
		id: ID,
		accessibilityInfoProvider: FieldItemAccessibilityInfoProvider = FieldItemAccessibilityInfoProvider(),
		backgroundColorStyle: ColorStyle = .clear,
		contentInsets: NSDirectionalEdgeInsets = .init(top: 14, leading: 16, bottom: 10, trailing: 16),
		iconAdjustsImageSizeForAccessibilityContentSizeCategory: Bool = true,
		iconTintColorStyle: ColorStyle? = Self.defaultTintColorStyle,
		respondersFacade: FieldItemRespondersFacade = FieldItemRespondersFacade(),
		tintColorStyle: ColorStyle = Self.defaultTintColorStyle,
		titleAdjustsFontForContentSizeCategory: Bool = true,
		titleColorStyle: ColorStyle = .secondaryLabel,
		titleFontStyle: FontStyle = .subheadline,
		titleNumberOfLines: Int = 0,
		titleTintColorStyle: ColorStyle = Self.defaultTintColorStyle
	) -> FieldItem<ID> {
		FieldItem(
			accessibilityInfoProvider: accessibilityInfoProvider,
			accessoryButtonFullConfiguration: accessoryButtonFullConfiguration,
			backgroundColorStyle: backgroundColorStyle,
			contentInsets: contentInsets,
			delegate: delegate,
			iconAdjustsImageSizeForAccessibilityContentSizeCategory: iconAdjustsImageSizeForAccessibilityContentSizeCategory,
			iconTintColorStyle: iconTintColorStyle,
			id: id,
			respondersFacade: respondersFacade,
			tintColorStyle: tintColorStyle,
			titleAdjustsFontForContentSizeCategory: titleAdjustsFontForContentSizeCategory,
			titleColorStyle: titleColorStyle,
			titleFontStyle: titleFontStyle,
			titleNumberOfLines: titleNumberOfLines,
			titleTintColorStyle: titleTintColorStyle
		)
	}

	static func filledUIConfigurationUpdateHandler(button: Button) {
		guard var updatedConfiguration = button.configuration else {
			assertionFailure("?")
			return
		}

		updatedConfiguration.imagePlacement = button.traitCollection.preferredContentSizeCategory.isAccessibilityCategory
		? .top
		: .leading

		updatedConfiguration.background.backgroundColor = button.isHighlighted
		? ColorStyle.brand.highlightedColor
		: ColorStyle.brand.color

		button.configuration = updatedConfiguration
	}

	static func textFieldItem<ID: IDType>(
		delegate: ITextFieldItemDelegate,
		fieldItem: FieldItem<ID>,
		placeholder: String,
		textColorStyle: ColorStyle = .label,
		textAdjustsFontForContentSizeCategory: Bool = true,
		textAdjustsFontSizeToFitWidth: Bool = true,
		textFieldBorderStyle: UITextField.BorderStyle = .none,
		textFieldInputTraits: TextInputTraits = Self.defaultTextFieldInputTraits,
		textFieldTintColorStyle: ColorStyle = Self.defaultTintColorStyle,
		textFontStyle: FontStyle = .body,
		toolbarItems: [UIBarButtonItem] = [],
		toolbarNavigationItemsManager: TextFieldItemToolbarNavigationItemsManager = TextFieldItemToolbarNavigationItemsManager(),
		toolbarTintColorStyle: ColorStyle = Self.defaultTintColorStyle
	) -> TextFieldItem<ID> {
		TextFieldItem(
			delegate: delegate,
			fieldItem: fieldItem,
			placeholder: placeholder,
			textAdjustsFontForContentSizeCategory: textAdjustsFontForContentSizeCategory,
			textAdjustsFontSizeToFitWidth: textAdjustsFontSizeToFitWidth,
			textColorStyle: textColorStyle,
			textFieldBorderStyle: textFieldBorderStyle,
			textFieldInputTraits: textFieldInputTraits,
			textFieldTintColorStyle: textFieldTintColorStyle,
			textFontStyle: textFontStyle,
			toolbarItems: toolbarItems,
			toolbarNavigationItemsManager: toolbarNavigationItemsManager,
			toolbarTintColorStyle: toolbarTintColorStyle
		)
	}

	static func fieldViewDoneToolbarItems(
		doneRespondersFacade: FieldItemRespondersFacade,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> [UIBarButtonItem] {
		[
			UIBarButtonItem(systemItem: .flexibleSpace),
			UIBarButtonItem(
				systemItem: .done,
				primaryAction: UIAction { [weak doneRespondersFacade] _ in
					didTapBarButtonItemFeedbackGenerator.impactOccurred()

					guard let doneCurrentResponderProvider = doneRespondersFacade?.responderProvider,
						  let doneCurrentResponder = doneCurrentResponderProvider()
					else {
						assertionFailure("?")
						return
					}

					doneCurrentResponder.resignFirstResponder()
				}
			)
		]
	}
}
