//
//  NetworkClient.swift
//  Nation
//
//  Created by Anderson Bressane on 04/10/2024.
//

import Foundation

enum NetworkError: Error, Equatable {
    case noConnection
    case badURL
    case noData
    case invalidResponse
    case parsingError
    case httpError(Int)
}

protocol NetworkClientProtocol {
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
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
