//
//  NetworkClient.swift
//  Nation
//
//  Created by Anderson Bressane on 04/10/2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case noData
    case invalidResponse
    case parsingError
    case httpError(Int)
}

protocol NetworkClientProtocol {
    func fetchData<T: Codable>(endPoint: EndpointProtocol, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkClient: NetworkClientProtocol {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Codable>(endPoint: EndpointProtocol, completion: @escaping (Result<T, NetworkError>) -> Void) {
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
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.parsingError))
            }
        }
    }
}
