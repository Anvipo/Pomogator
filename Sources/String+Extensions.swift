//
//  String+Extensions.swift
//  Pomogator
//
//  Created by Anvipo on 30.08.2021.
//

import Foundation

// MARK: - Constants extension

extension String {
	static var nonBreakingSpace: Self {
		"\u{00a0}"
	}

	static var nonBreakingHyphen: Self {
		"\u{2011}"
	}

	static func random(length: Int, alphabet: Self) -> Self {
		let chars = (0..<length).compactMap { _ in
			alphabet.randomElement()
		}

		return Self(chars)
	}
}

// MARK: - Other extension

extension String {
	var nonBreakingHyphened: Self {
		replacingOccurrences(of: "-", with: Self.nonBreakingHyphen)
	}

	var nonBreakingSpaced: Self {
		replacingOccurrences(of: " ", with: Self.nonBreakingSpace)
	}

	var decimalFromEN: Decimal {
		let result = Decimal(string: self)

		if result == nil {
			assertionFailure("?")
		}

		return result ?? 0
	}

	var isNumeric: Bool {
		CharacterSet.decimalDigits.isSuperset(of: .init(charactersIn: self))
	}

	// swiftlint:disable:next discouraged_optional_boolean
	var boolValue: Bool? {
		Bool(self)
	}

	/// Возвращает все рейнджи переданной строки, входящие в состав исходной
	func ranges(of searchString: Self) -> [Range<Self.Index>] {
		var result = [Range<Self.Index>]()

		var currentRange = startIndex..<endIndex
		while let range = range(of: searchString, range: currentRange) {
			result.append(range)
			currentRange = range.upperBound..<currentRange.upperBound
		}

		return result
	}
}

extension String {
	subscript(index: Int) -> Character {
		self[self.index(self.startIndex, offsetBy: index)]
	}

	subscript(value: PartialRangeUpTo<Int>) -> Self {
		Self(self[..<index(startIndex, offsetBy: value.upperBound)])
	}

	subscript(value: PartialRangeThrough<Int>) -> Self {
		Self(self[...index(startIndex, offsetBy: value.upperBound)])
	}

	subscript(value: PartialRangeFrom<Int>) -> Self {
		Self(self[index(startIndex, offsetBy: value.lowerBound)...])
	}
}

extension String {
	/// Проверяет удовлетворяет ли строка регулярному выражению
	func matches(regexPattern: Self) -> Bool {
		let wholeRange = startIndex..<endIndex
		if let match = range(of: regexPattern, options: .regularExpression),
		   wholeRange == match {
			return true
		}

		return false
	}

	/// Возвращает список элементов(подстрок), которые удовлетворяют regexp
	func matches(regexPattern: Self) -> [Self] {
		guard let regularExpression = try? NSRegularExpression(pattern: regexPattern) else {
			return []
		}

		return regularExpression
			.matches(in: self, options: [], range: NSRange(startIndex..., in: self))
			.compactMap { Range($0.range, in: self).map { Self(self[$0]) } }
	}

	/// Проверка есть ли в строке такая подстрока, которая удовлетворяет regexp
	func confirms(regex: Self) -> Bool {
		guard let regularExpression = try? NSRegularExpression(pattern: regex) else {
			return false
		}

		return !regularExpression
			.matches(in: self, options: [], range: NSRange(startIndex..., in: self))
			.compactMap { Range($0.range, in: self).map { Self(self[$0]) } }.isEmpty
	}
}
