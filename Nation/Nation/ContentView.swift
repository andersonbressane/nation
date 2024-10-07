//
//  ContentView.swift
//  Nation
//
//  Created by Anderson Bressane on 04/10/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ListView(layoutViewModel: viewModel.layoutViewModels)
            }
            .navigationBarTitle("Nation Data", displayMode: .large)
        }.onAppear() {
            Task {
                try await fetchData()
            }
        }
        .overlay (
            AlertComponentView(isShowing: $viewModel.isShowingAlert, message: viewModel.alertMessage, style: .error)
                .padding()
            ,
            alignment: .top
        )
    }
    
    func fetchData() async throws {
        Task {
            do {
                _ = try await viewModel.fetchData()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}

#Preview {
    ContentView(viewModel: ViewModel())
}
