//
//  BaseAssembly.swift
//  Pomogator
//
//  Created by Anvipo on 08.01.2023.
//

@MainActor
class BaseAssembly {}

extension BaseAssembly {
	var dependenciesStorage: DependenciesStorage {
		.shared
	}
}
