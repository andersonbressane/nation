//
//  AlertComponent.swift
//  BlueBubble
//
//  Created by Anderson Franco on 10/04/2024.
//

import SwiftUI

enum AlertComponentViewStyle {
    case error
}

struct AlertComponentView: View {
    @Binding var isShowing: Bool
    
    let message: String
    let style: AlertComponentViewStyle
    
    private var color: Color {
        switch style {
        case .error:
                .red
        }
    }
    
    private var icon: String {
        switch style {
        case .error:
            return "exclamationmark.circle.fill"
        }
    }
    
    var body: some View {
        VStack {
            if isShowing {
                HStack(alignment: .top) {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(color)
                    
                    Text(message)
                        .foregroundColor(color)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        isShowing = false
                    }, label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(UIColor.systemGray2))
                    })
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .modifier(CardModifier())
            } else {
                EmptyView()
            }
        }
        .animation(.default)
    }
}
