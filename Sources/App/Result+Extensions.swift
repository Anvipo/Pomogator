//
//  Result+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 11.01.2023.
//

extension Result {
	var value: Success? {
		switch self {
		case let .success(value): value
		case .failure: nil
		}
	}
}
