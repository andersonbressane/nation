//
//  Untitled.swift
//  Nation
//
//  Created by Anderson Bressane on 06/10/2024.
//
import SwiftUI

enum ViewModelProtocolError: Error {
    case invalidData
}

protocol ViewModelProtocol {
    func fetchData(year: Int?) async throws -> [LayoutViewModel]
}

class ViewModel: ViewModelProtocol, ObservableObject {
    
    let dataSource: DataSourceProtocol
    
    @Published var layoutViewModels: [LayoutViewModel] = []
    
    init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchData(year: Int? = nil) async throws -> [LayoutViewModel] {
        do {
            let nation = try await self.dataSource.fetchNation(year: year)
            
            self.layoutViewModels = getNationViewModel(from: nation.data)
            
            let states = try await self.dataSource.fetchStates(year: year)
            
            self.layoutViewModels.append(contentsOf: getStatesLayoutViewModel(from: states.data))
            
            return self.layoutViewModels
        } catch {
            throw error
        }
    }
    
    private func getNationViewModel(from nations: [Nation]) -> [LayoutViewModel] {
        return nations.compactMap({ LayoutViewModel(model: $0) })
    }
    
    private func getStatesLayoutViewModel(from states: [State]) -> [LayoutViewModel] {
        return states.compactMap({ LayoutViewModel(model: $0) })
    }
}
