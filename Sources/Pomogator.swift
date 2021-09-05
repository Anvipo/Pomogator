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
			textProperties: PlainLabelItem<ID>.makeTextProperties().apply { textProperties in
				if let textAlignment {
					textProperties.alignment = textAlignment
				}
				if let textColor {
					textProperties.color = textColor
				}
				if let textFont {
					textProperties.font = textFont
				}
			},
			tintColor: tintColor ?? Self.defaultTintColor.uiColor
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
	static var defaultTintColor: Color {
		.brand
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
			contentInsets: contentInsets ?? .default(top: 14, bottom: 10),
			currentResponderProvider: currentResponderProvider ?? CurrentResponderProvider(),
			delegate: delegate,
			iconTintColor: iconTintColor ?? Self.defaultTintColor.uiColor,
			id: id,
			textColor: textColor ?? Color.label.uiColor,
			textFieldBorderStyle: textFieldBorderStyle ?? .none,
			textFieldTintColor: textFieldTintColor ?? Self.defaultTintColor.uiColor,
			textFont: textFont ?? Font.body.uiFont,
			tintColor: tintColor ?? Self.defaultTintColor.uiColor,
			titleColor: titleColor ?? Color.secondaryLabel.uiColor,
			titleFont: titleFont ?? Font.subheadline.uiFont,
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
