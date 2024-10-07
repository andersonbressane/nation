//
//  NetworkClient.swift
//  Nation
//
//  Created by Anderson Bressane on 04/10/2024.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case noConnection
    case badURL
    case noData
    case invalidResponse
    case parsingError
    case unknownError(String)
    case httpError(Int)
}

protocol NetworkClientProtocol {
    func fetchData(endPoint: EndpointProtocol) async throws -> Data
    func fetchData(endPoint: EndpointProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

class NetworkClient: NetworkClientProtocol {
    let session: URLSession
    let networkMonitor: NetworkMonitorProtocol
    
    init(session: URLSession = URLSession.shared, networkMonitor: NetworkMonitorProtocol = NetworkMonitor()) {
        self.session = session
        self.networkMonitor = networkMonitor
    }
    
    func fetchData(endPoint: EndpointProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if !networkMonitor.checkConnection() {
            completion(.failure(.noConnection))
            return
        }
        
        guard let url = endPoint.url else {
            completion(.failure(.badURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func fetchData(endPoint: EndpointProtocol) async throws -> Data {
        if !networkMonitor.checkConnection() {
            throw NetworkError.noConnection
        }
        
        guard let url = endPoint.url else {
            throw NetworkError.badURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            if data.isEmpty {
                throw NetworkError.noData
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            
            return data
        } catch {
            throw NetworkError.unknownError(error.localizedDescription)
        }
    }
}
