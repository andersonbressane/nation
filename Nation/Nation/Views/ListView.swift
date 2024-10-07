//
//  ListView.swift
//  Nation
//
//  Created by Anderson Bressane on 07/10/2024.
//
import SwiftUI

struct ListView: View {
    let layoutViewModel: [LayoutViewModel]
    
    var body: some View {
        List {
            ForEach(layoutViewModel, id: \.id) { layoutViewModel in
                CartView(layoutViewModel: layoutViewModel)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}
