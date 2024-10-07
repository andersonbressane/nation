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
}

class Endpoint: EndpointProtocol {
    var url: URL? {
        guard var urlComponent = URLComponents(string: Constants.baseURL) else { return nil }
        
        var queryItems: [URLQueryItem] = [
            .init(name: "measures", value: "Population"),
            .init(name: "year", value: "latest")
        ]
        
        switch action {
        case .getNation:
            queryItems.append(.init(name: "drilldowns", value: "Nation"))
        case .getState:
            queryItems.append(.init(name: "drilldowns", value: "State"))
        case .none:
            return nil
        }
        
        urlComponent.queryItems = queryItems

        return urlComponent.url
    }
    
    enum Action {
        case getNation
        case getState
        case none
    }
    
    let action: Action
    
    init(action: Action, year: Int? = nil) {
        self.action = action
    }
}
