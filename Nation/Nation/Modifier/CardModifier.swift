//
//  CardModifier.swift
//  BlueBubble
//
//  Created by Anderson Franco on 10/04/2024.
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Color(UIColor.tertiarySystemBackground)
            )
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 1, y: 1)
    }
}
