//
//  DataSourceProtocol.swift
//  Nation
//
//  Created by Anderson Bressane on 06/10/2024.
//

import Foundation

enum DataSourceError: Error {
    case parsingError
    case noResult
}

protocol DataSourceProtocol {
    func fetchNation(year: Int?) async throws -> NationResponse
    func fetchStates(year: Int?) async throws -> StateResponse
}

class DataSource: DataSourceProtocol {
    let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchNation(year: Int? = nil) async throws -> NationResponse {
        do {
            let data = try await self.networkClient.fetchData(endPoint: Endpoint(action: .getNation, year: year))
            
            let response = try JSONDecoder().decode(NationResponse.self, from: data)
            
            if response.data.isEmpty {
                throw DataSourceError.noResult
            }
            
            return response
        } catch _ as DecodingError {
            throw DataSourceError.parsingError
        } catch {
            throw error
        }
    }
    
    func fetchStates(year: Int? = nil) async throws -> StateResponse {
        do {
            let data = try await self.networkClient.fetchData(endPoint: Endpoint(action: .getState, year: year))
            
            let response = try JSONDecoder().decode(StateResponse.self, from: data)
            
            if response.data.isEmpty {
                throw DataSourceError.noResult
            }
            
            return response
        } catch _ as DecodingError {
            throw DataSourceError.parsingError
        } catch {
            throw error
        }
    }
}

