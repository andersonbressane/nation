//
//  Untitled.swift
//  Nation
//
//  Created by Anderson Bressane on 06/10/2024.
//
import SwiftUI

enum LoadingState {
    case loading, success, failed, none
}

enum ViewModelProtocolError: Error {
    case noData
}

protocol ViewModelProtocol {
    func fetchData(year: Int?) async throws
}

class ViewModel: ViewModelProtocol, ObservableObject {
    let dataSource: DataSourceProtocol
    
    @Published var layoutViewModels: [LayoutViewModel] = []
    
    @Published var loadingState: LoadingState = .none
    
    @Published var isShowingAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertStyle: AlertComponentViewStyle = .error
    
    func showError(message: String?, style: AlertComponentViewStyle) {
        DispatchQueue.main.async {
            self.isShowingAlert = true
            self.alertMessage = message ?? ""
            self.alertStyle = style
        }
    }
    
    init(dataSource: DataSourceProtocol = DataSource(networkClient: NetworkClient())) {
        self.dataSource = dataSource
    }
    
    func fetchData(year: Int? = nil) async throws {
        DispatchQueue.main.async {
            self.loadingState = .loading
        }
        
        do {
            let nation = try await self.dataSource.fetchNation(year: year)
            
            var list = getNationViewModel(from: nation.data)
            
            let states = try await self.dataSource.fetchStates(year: year)
            
            list.append(contentsOf: getStatesLayoutViewModel(from: states.data))
            
            if list.isEmpty {
                throw ViewModelProtocolError.noData
            }
            
            DispatchQueue.main.async {
                self.loadingState = .success
                self.layoutViewModels = list
            }
        } catch {
            DispatchQueue.main.async {
                self.showError(message: error.localizedDescription, style: .error)
                self.loadingState = .failed
            }
            
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
