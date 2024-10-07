//
//  CartView.swift
//  Nation
//
//  Created by Anderson Bressane on 07/10/2024.
//

import SwiftUI

struct CartView: View {
    let layoutViewModel: LayoutViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(layoutViewModel.type == .nation ? "Nation" : "State")
                    .font(.footnote)
                Spacer()
                
                Text(layoutViewModel.year)
                    .background(.red)
                    .foregroundStyle(.white)
                    .cornerRadius(4)
            }
            .padding()
                
            Text(layoutViewModel.name)
                .font(layoutViewModel.type == .nation ? .title : .title3)
                .padding()
                .foregroundStyle(.primary)
            
            Text("\(layoutViewModel.population) people")
                .font(.headline)
                .padding()
                .foregroundStyle(.secondary)
        }
        .modifier(CardModifier())
    }
}

#Preview {
    let layoutViewModel = LayoutViewModel(model: Nation(id: "1234", name: "United States", idYear: 2022, year: "2022", population: 300000000, slug: "united-states"))
    
    CartView(layoutViewModel: layoutViewModel)
        .padding()
}
