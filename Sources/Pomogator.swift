//
//  Pomogator.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//
// swiftlint:disable function_parameter_count

import UIKit

@MainActor
enum Pomogator {}

extension Pomogator {
	static var defaultLabelTextAlignment: UIListContentConfiguration.TextProperties.TextAlignment {
		.center
	}

	static var defaultLabelTextFont: Font {
		.title2
	}
}

extension Pomogator {
	static func headerItem<ID: IDType>(
		id: ID,
		text: String
	) -> PlainLabelHeaderItem<ID> {
		PlainLabelHeaderItem(
			id: id,
			text: text
		)
	}

	static func labelItem<ID: IDType>(
		id: ID,
		text: String,
		accessoryInfo: TableViewCellAccessoryInfo? = nil,
		backgroundColorHandler: ((UICellConfigurationState) -> UIColor)? = nil,
		textAlignment: UIListContentConfiguration.TextProperties.TextAlignment? = nil,
		textColor: UIColor? = nil,
		textFont: UIFont? = nil,
		tintColor: UIColor? = nil
	) -> PlainLabelItem<ID> {
		PlainLabelItem(
			accessoryInfo: accessoryInfo,
			backgroundColorHandler: backgroundColorHandler,
			id: id,
			text: text,
			textAlignment: textAlignment ?? Self.defaultLabelTextAlignment,
			textColor: textColor ?? Self.defaultTextColor.uiColor,
			textFont: textFont ?? Self.defaultLabelTextFont.uiFont,
			tintColor: tintColor
		)
	}

	static func stringFieldItem<ID: IDType>(
		id: ID,
		content: StringFieldItem<ID>.Content,
		textKeyboardType: UIKeyboardType,
		delegate: StringFieldItemDelegate
	) -> StringFieldItem<ID> {
		StringFieldItem(
			content: content,
			delegate: delegate,
			fieldItem: fieldItem(id: id, delegate: delegate),
			textKeyboardType: textKeyboardType
		)
	}

	static func dateFieldItem<ID: IDType>(
		id: ID,
		content: DateFieldItem<ID>.Content,
		calendar: Calendar,
		delegate: DateFieldItemDelegate,
		getDateText: @escaping (Date) -> String,
		getDate: @escaping (String) -> Date?
	) -> DateFieldItem<ID> {
		DateFieldItem(
			calendar: calendar,
			content: content,
			datePickerMode: .dateAndTime,
			datePickerStyle: .wheels,
			datePickerTintColor: Self.defaultTintColor.uiColor,
			delegate: delegate,
			fieldItem: fieldItem(id: id, delegate: delegate, textFieldTintColor: .clear),
			getDateText: getDateText,
			getDate: getDate,
			shouldEraseSeconds: true
		)
	}

	static func configureToolbarItems<T: FieldItemContainer>(
		in item: inout T,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator,
		previousResponderNavigationHandler: (() -> Void)? = nil,
		nextResponderNavigationHandler: (() -> Void)? = nil
	) {
		let respondersNavigationFacade = RespondersNavigationFacade(
			nextResponderNavigationHandler: nextResponderNavigationHandler,
			previousResponderNavigationHandler: previousResponderNavigationHandler
		)
		item.respondersNavigationFacade = respondersNavigationFacade

		let itemDoneToolbarItems = fieldViewDoneToolbarItems(
			doneResponderProvider: item.currentResponderProvider,
			didTapBarButtonItemFeedbackGenerator: didTapBarButtonItemFeedbackGenerator
		)

		item.toolbarItems = respondersNavigationFacade.barButtonItems + itemDoneToolbarItems
	}
}

extension Pomogator {
	static func defaultButtonConfiguration(
		title: String? = nil,
		image: UIImage? = nil
	) -> UIButton.Configuration {
		.filled().apply { configuration in
			configuration.title = title
			configuration.image = image
			configuration.buttonSize = .large
			configuration.cornerStyle = .fixed
			configuration.background.backgroundColor = Color.brand.uiColor
			configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
				var outgoing = incoming
				outgoing.foregroundColor = Color.labelOnBrand.uiColor
				outgoing.font = Font.callout.uiFont
				return outgoing
			}
		}
	}

	static func defaultUIConfigurationUpdateHandler(button: Button) {
		guard var updatedConfiguration = button.configuration else {
			assertionFailure("?")
			return
		}

		updatedConfiguration.background.backgroundColor = button.isHighlighted
		? Color.brand.highlightedUIColor
		: Color.brand.uiColor

		button.configuration = updatedConfiguration
	}
}

private extension Pomogator {
	static var defaultTitleColor: Color {
		.secondaryLabel
	}

	static var defaultTitleFont: Font {
		.subheadline
	}

	static var defaultTextColor: Color {
		.label
	}

	static var defaultTintColor: Color {
		.brand
	}

	static var defaultFieldItemFont: Font {
		.body
	}

	static var defaultContentInsets: NSDirectionalEdgeInsets {
		.default(top: 14, bottom: 10)
	}

	static func fieldItem<ID: IDType>(
		id: ID,
		delegate: FieldItemDelegate,
		backgroundColor: UIColor? = nil,
		contentInsets: NSDirectionalEdgeInsets? = nil,
		currentResponderProvider: CurrentResponderProvider? = nil,
		iconTintColor: UIColor? = nil,
		textColor: UIColor? = nil,
		textFieldBorderStyle: UITextField.BorderStyle? = nil,
		textFieldTintColor: UIColor? = nil,
		textFont: UIFont? = nil,
		tintColor: UIColor? = nil,
		titleColor: UIColor? = nil,
		titleFont: UIFont? = nil,
		titleNumberOfLines: Int = 1,
		titleTintColor: UIColor? = nil,
		toolbarItems: [UIBarButtonItem] = [],
		toolbarTintColor: UIColor? = nil
	) -> FieldItem<ID> {
		FieldItem(
			backgroundColor: backgroundColor ?? .clear,
			contentInsets: contentInsets ?? Self.defaultContentInsets,
			currentResponderProvider: currentResponderProvider ?? CurrentResponderProvider(),
			delegate: delegate,
			iconTintColor: iconTintColor ?? Self.defaultTintColor.uiColor,
			id: id,
			textColor: textColor ?? Self.defaultTextColor.uiColor,
			textFieldBorderStyle: textFieldBorderStyle ?? .none,
			textFieldTintColor: textFieldTintColor ?? Self.defaultTintColor.uiColor,
			textFont: textFont ?? Self.defaultFieldItemFont.uiFont,
			tintColor: tintColor ?? Self.defaultTintColor.uiColor,
			titleColor: titleColor ?? Self.defaultTitleColor.uiColor,
			titleFont: titleFont ?? Self.defaultTitleFont.uiFont,
			titleNumberOfLines: titleNumberOfLines,
			titleTintColor: titleTintColor ?? Self.defaultTintColor.uiColor,
			toolbarItems: toolbarItems,
			toolbarTintColor: toolbarTintColor ?? Self.defaultTintColor.uiColor
		)
	}

	static func fieldViewDoneToolbarItems(
		doneResponderProvider: CurrentResponderProvider,
		didTapBarButtonItemFeedbackGenerator: UIImpactFeedbackGenerator
	) -> [UIBarButtonItem] {
		[
			UIBarButtonItem(systemItem: .flexibleSpace),
			UIBarButtonItem(
				systemItem: .done,
				primaryAction: UIAction { [weak doneResponderProvider] _ in
					didTapBarButtonItemFeedbackGenerator.impactOccurred()
					doneResponderProvider?.currentResponder?.resignFirstResponder()
				}
			)
		]
	}
}
