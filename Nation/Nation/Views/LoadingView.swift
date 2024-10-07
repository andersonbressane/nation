//
//  LoadingView.swift
//  Nation
//
//  Created by Anderson Bressane on 07/10/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            Text("Loading...")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
        }
    }
}

#Preview {
    LoadingView()
}
