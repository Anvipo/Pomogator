//
//  ReuseIdentifiable.swift
//  Pomogator
//
//  Created by Anvipo on 20.01.2023.
//

@MainActor
protocol ReuseIdentifiable {
	static var reuseID: String { get }
}
