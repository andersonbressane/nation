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
    var method: HTTPMethod { get }
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
        }
        
        return urlComponent.url
    }
    
    let method: HTTPMethod = .get
    
    enum Action {
        case getNation
        case getState
    }
    
    let action: Action
    
    init(action: Action) {
        self.action = action
    }
}
