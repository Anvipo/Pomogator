//
//  Result+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

extension Result {
	var value: Success? {
		switch self {
		case let .success(value):
			return value

		default:
			return nil
		}
	}

	var error: Failure? {
		switch self {
		case let .failure(error):
			return error

		default:
			return nil
		}
	}

	func asVoid() -> Result<Void, Error> {
		switch self {
		case .success:
			return .success(())

		case let .failure(error):
			return .failure(error)
		}
	}
}
