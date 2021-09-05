//
//  SharedPomogator.swift
//  Pomogator
//
//  Created by Anvipo on 11.03.2023.
//

import UIKit
import WidgetKit

extension Calendar {
	static var pomogator: Self {
		var result = autoupdatingCurrent
		result.locale = .pomogator
		return result
	}
}

extension Locale {
	static var pomogator: Self {
		autoupdatingCurrent
	}
}

extension UserDefaults {
	static var sharedWithWidget: Self {
		.init(suiteName: "group.ru.anvipo.pomogator.shared")!
	}
}

extension UIColor {
	static var brand: UIColor {
#if os(iOS)
		return UIColor { traitCollection in
			switch traitCollection.userInterfaceStyle {
			case .unspecified, .light: UIColor(red: 0, green: 0.584, blue: 0.251, alpha: 1)
			// TODO: dark theme
			case .dark: UIColor(red: 0, green: 0.584, blue: 0.251, alpha: 1)
			@unknown default: UIColor(red: 0, green: 0.584, blue: 0.251, alpha: 1)
			}
		}
#else
		return UIColor(red: 0, green: 0.584, blue: 0.251, alpha: 1)
#endif
	}

	static var labelOnBrand: UIColor {
		white
	}
}

protocol IKeyValueStore: AnyObject {
	func object(forKey defaultName: String) -> Any?
	func set(_ value: Any?, forKey defaultName: String)
	@discardableResult
	func synchronize() -> Bool
}

extension UserDefaults: IKeyValueStore {}
extension NSUbiquitousKeyValueStore: IKeyValueStore {}

final class KeyValueStoreFacade {
	private let iCloud: IKeyValueStore
	private let local: IKeyValueStore
	private let sharedLocal: IKeyValueStore

	init(iCloud: IKeyValueStore, local: IKeyValueStore, shared: IKeyValueStore) {
		self.iCloud = iCloud
		self.local = local
		self.sharedLocal = shared
	}
}

extension KeyValueStoreFacade {
	enum SourceType: CaseIterable {
		case iCloud
		case local
		case sharedLocal
	}

	func value<T>(forKey defaultName: String, from sourceTypes: [SourceType]) -> T? {
		var stores = [IKeyValueStore]()
		for sourceType in sourceTypes {
			switch sourceType {
			case .iCloud: stores.append(iCloud)
			case .local: stores.append(local)
			case .sharedLocal: stores.append(sharedLocal)
			}
		}

		if sourceTypes.contains(.iCloud) {
			let succeed = iCloud.synchronize()

			if !succeed {
				assertionFailure("This app was not built with the proper entitlement requests.")
			}
		}

		guard let foundObject = stores.compactMap({ $0.object(forKey: defaultName) }).first else {
			return nil
		}

		guard let castedFoundObject = foundObject as? T else {
			assertionFailure("?")
			return nil
		}

		return castedFoundObject
	}

	func set(value: Any?, forKey defaultName: String, to sourceTypes: [SourceType]) {
		assert(sourceTypes.isNotEmpty)

		var stores = [IKeyValueStore]()
		for sourceType in sourceTypes {
			switch sourceType {
			case .iCloud: stores.append(iCloud)
			case .local: stores.append(local)
			case .sharedLocal: stores.append(sharedLocal)
			}
		}

		for store in stores {
			store.set(value, forKey: defaultName)
		}

		if sourceTypes.contains(.iCloud) {
			let succeed = iCloud.synchronize()

			if !succeed {
				assertionFailure("This app was not built with the proper entitlement requests.")
			}
		}
	}
}
