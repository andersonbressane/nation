//
//  NetworkLayerTests.swift
//  Nation
//
//  Created by Anderson Bressane on 05/10/2024.
//

import XCTest
@testable import Nation

class NetworkLayerTests: XCTestCase {
    func testConnectivityFail() {
        let networkClient = NetworkClient(networkMonitor: NetworkMonitorFailMock())
        
        networkClient.fetchData(endPoint: Endpoint(action: .getNation)) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .noConnection)
            }
        }
    }
    
    func testConnectivitySuccess() {
        let networkClient = NetworkClient(networkMonitor: NetworkMonitorSuccessMock())
        
        networkClient.fetchData(endPoint: Endpoint(action: .getNation)) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testBadURL() {
        let networkClient = NetworkClient(networkMonitor: NetworkMonitorSuccessMock())
        
        networkClient.fetchData(endPoint: Endpoint(action: .none)) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .badURL)
            }
        }
    }
}

class URLSessionMock: URLProtocol {
    
}
