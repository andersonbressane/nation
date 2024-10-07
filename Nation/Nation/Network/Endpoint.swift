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
        
        urlComponent.queryItems = [
            .init(name: "measures", value: "Population")
        ]
        
        if let year = self.year {
            urlComponent.queryItems = [
                .init(name: "year", value: "\(year)")
            ]
        }
        
        return urlComponent.url
    }
    
    enum Action {
        case getNation
        case getState
        case none
    }
    
    let action: Action
    let year: Int?
    
    init(action: Action, year: Int? = nil) {
        self.action = action
        self.year = year
    }
}
