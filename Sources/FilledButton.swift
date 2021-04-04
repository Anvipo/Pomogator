//
//  FilledButton.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import SwiftUI

struct FilledButton {
	let title: String
	let action: () -> Void

	private let height: CGFloat = 44.0
}

extension FilledButton: View {
	var body: some View {
		Button(action: action) {
			HStack {
				Spacer()

				Text(title)
					.accentColor(.white)

				Spacer()
			}
		}
		.frame(width: nil, height: height, alignment: .center)
		.background(Color.purple)
		.cornerRadius(height / 3)
	}
}
