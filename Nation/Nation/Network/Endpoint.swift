//
//  Endpoint.swift
//  Nation
//
//  Created by Anderson Bressane on 04/10/2024.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
}

public protocol EndpointProtocol {
    var url: URL? { get }
    var params: [String: Any]? { get }
}

class Endpoint: EndpointProtocol {
    var url: URL? {
        guard var urlComponent = URLComponents(string: Constants.baseURL) else { return nil }
        
        urlComponent.queryItems = [
            .init(name: "measures", value: "Population")
        ]
        
        switch action {
        case .getNation:
            urlComponent.queryItems = [
                .init(name: "drilldowns", value: "Nation")
            ]
        case .getState:
            urlComponent.queryItems = [
                .init(name: "drilldowns", value: "State")
            ]
        case .none:
            return nil
        }
        
        if let query = params?.compactMap({ URLQueryItem(name: $0.key, value: String(describing: $0.value)) }) {
            urlComponent.queryItems = query
        }
        
        return urlComponent.url
    }
        
    var params: [String: Any]?
    
    enum Action {
        case getNation
        case getState
        case none
    }
    
    let action: Action
    
    init(action: Action, params: [String: Any]? = nil) {
        self.action = action
        self.params = params
    }
}
