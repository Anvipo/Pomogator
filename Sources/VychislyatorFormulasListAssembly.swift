//
//  VychislyatorFormulasListAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 25.09.2021.
//

import UIKit

final class VychislyatorFormulasListAssembly: BaseAssembly {}

extension VychislyatorFormulasListAssembly {
	// swiftlint:disable:next function_body_length
	func formulasSection(
		onTapDailyCalorieIntakeButton: @escaping (Button) -> Void,
		onTapDailyCalorieIntakeAccessoryButton: @escaping (Button) -> Void,
		onTapBodyMassIndexButtonButton: @escaping (Button) -> Void,
		onTapBodyMassIndexButtonAccessoryButton: @escaping (Button) -> Void
	) -> VychislyatorFormulasListSection {
		let accessoryButtonUIConfiguration = UIButton.Configuration.plain().apply { configuration in
			configuration.image = Image.questionmarkCircle.uiImage
			configuration.buttonSize = .large
			configuration.contentInsets = .zero
			configuration.baseForegroundColor = Color.brand.uiColor
		}
		let accessoryButtnUIConfigurationUpdateHandler: (Button) -> Void = { accessoryButton in
			accessoryButton.configuration?.baseForegroundColor = accessoryButton.isHighlighted
			? Color.brand.uiColor.withBrightnessComponent(0.8)
			: Color.brand.uiColor
		}

		let dailyCalorieIntakeButton = PlainButtonItem(
			accessoryButtonFullConfiguration: .init(
				uiConfiguration: accessoryButtonUIConfiguration,
				uiConfigurationUpdateHandler: accessoryButtnUIConfigurationUpdateHandler,
				onTap: onTapDailyCalorieIntakeAccessoryButton
			),
			backgroundConfiguration: .clear(),
			buttonFullConfiguration: .init(
				uiConfiguration: Pomogator.defaultButtonConfiguration(
					title: String(localized: "Daily calorie intake")
				),
				uiConfigurationUpdateHandler: Pomogator.defaultUIConfigurationUpdateHandler(button:),
				onTap: onTapDailyCalorieIntakeButton
			),
			id: VychislyatorFormulasListItemIdentifier.dailyCalorieIntake
		)

		let spacer = PlainSpacerItem(
			backgroundConfiguration: .clear(),
			id: VychislyatorFormulasListItemIdentifier.spacer1,
			type: .vertical(16)
		)

		let bodyMassIndexButton = PlainButtonItem(
			accessoryButtonFullConfiguration: .init(
				uiConfiguration: accessoryButtonUIConfiguration,
				uiConfigurationUpdateHandler: accessoryButtnUIConfigurationUpdateHandler,
				onTap: onTapBodyMassIndexButtonAccessoryButton
			),
			backgroundConfiguration: .clear(),
			buttonFullConfiguration: .init(
				uiConfiguration: Pomogator.defaultButtonConfiguration(
					title: String(localized: "Body mass index")
				),
				uiConfigurationUpdateHandler: Pomogator.defaultUIConfigurationUpdateHandler(button:),
				onTap: onTapBodyMassIndexButtonButton
			),
			id: VychislyatorFormulasListItemIdentifier.bodyMassIndex
		)

		// swiftlint:disable:next force_try
		return try! VychislyatorFormulasListSection(
			id: .formulas,
			items: [
				dailyCalorieIntakeButton,
				spacer,
				bodyMassIndexButton
			]
		)
	}
}
