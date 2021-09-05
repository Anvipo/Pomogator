//
//  Pomogator.swift
//  Pomogator
//
//  Created by Anvipo on 12.09.2021.
//
// swiftlint:disable function_parameter_count

import UIKit

enum Pomogator {}

extension Pomogator {
	static func headerItem(text: String) -> PlainLabelHeaderItem {
		PlainLabelHeaderItem(text: text)
	}

	static func labelItem<ID: Hashable>(
		id: ID,
		text: String,
		accessoryInfo: TableViewCellAccessoryInfo? = nil,
		backgroundColor: UIColor? = nil,
		textAlignment: UIListContentConfiguration.TextProperties.TextAlignment = .center,
		textColor: UIColor = Self.defaultTextColor.uiColor,
		textFont: UIFont = Font.title2.uiFont,
		tintColor: UIColor? = nil
	) -> PlainLabelItem<ID> {
		PlainLabelItem(
			accessoryInfo: accessoryInfo,
			backgroundColor: backgroundColor,
			id: id,
			text: text,
			textAlignment: textAlignment,
			textColor: textColor,
			textFont: textFont,
			tintColor: tintColor
		)
	}

	static func stringFieldItem<ID: Hashable>(
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

	static func dateFieldItem<ID: Hashable>(
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
			configuration.cornerStyle = .capsule
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
		? Color.brand.uiColor.withBrightnessComponent(0.7)
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

	static func fieldItem<ID: Hashable>(
		id: ID,
		delegate: FieldItemDelegate,
		backgroundColor: UIColor = .clear,
		contentInsets: NSDirectionalEdgeInsets = Self.defaultContentInsets,
		currentResponderProvider: CurrentResponderProvider = CurrentResponderProvider(),
		iconTintColor: UIColor = Self.defaultTintColor.uiColor,
		textColor: UIColor = Self.defaultTextColor.uiColor,
		textFieldBorderStyle: UITextField.BorderStyle = .none,
		textFieldTintColor: UIColor = Self.defaultTintColor.uiColor,
		textFont: UIFont = Self.defaultFieldItemFont.uiFont,
		tintColor: UIColor = Self.defaultTintColor.uiColor,
		titleColor: UIColor = Self.defaultTitleColor.uiColor,
		titleFont: UIFont = Self.defaultTitleFont.uiFont,
		titleNumberOfLines: Int = 1,
		titleTintColor: UIColor = Self.defaultTintColor.uiColor,
		toolbarItems: [UIBarButtonItem] = [],
		toolbarTintColor: UIColor = Self.defaultTintColor.uiColor
	) -> FieldItem<ID> {
		FieldItem(
			backgroundColor: backgroundColor,
			contentInsets: contentInsets,
			currentResponderProvider: currentResponderProvider,
			delegate: delegate,
			iconTintColor: iconTintColor,
			id: id,
			textColor: textColor,
			textFieldBorderStyle: textFieldBorderStyle,
			textFieldTintColor: textFieldTintColor,
			textFont: textFont,
			tintColor: tintColor,
			titleColor: titleColor,
			titleFont: titleFont,
			titleNumberOfLines: titleNumberOfLines,
			titleTintColor: titleTintColor,
			toolbarItems: toolbarItems,
			toolbarTintColor: toolbarTintColor
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
