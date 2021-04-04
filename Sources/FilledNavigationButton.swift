//
//  FilledNavigationButton.swift
//  Pomogator
//
//  Created by Anvipo on 04.04.2021.
//

import SwiftUI

struct FilledNavigationButton<Destination: View> {
	init(
		title: String,
		destination: Destination,
		action: (() -> Void)? = nil
	) {
		self.title = title
		self.action = action
		self.destination = destination
	}

	private let title: String
	private let action: (() -> Void)?
	private let destination: Destination

	@State private var isDestinationActive = false
}

extension FilledNavigationButton: View {
	var body: some View {
		ZStack {
			NavigationLink(destination: destination, isActive: $isDestinationActive) {
				EmptyView()
			}

			FilledButton(title: title) {
				self.isDestinationActive = true
				action?()
			}
		}
	}
}
