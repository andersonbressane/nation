//
//  NetworkMonitorTests.swift
//  Nation
//
//  Created by Anderson Bressane on 05/10/2024.
//
import XCTest
@testable import Nation

class NetworkMonitorTests: XCTestCase {
    func testConnectionFail() {
        let networkMonitor = NetworkMonitorFailMock()
        XCTAssertFalse(networkMonitor.checkConnection())
    }
    
    func testConnectionSuccess() {
        let networkMonitor = NetworkMonitorSuccessMock()
        XCTAssertTrue(networkMonitor.checkConnection())
    }
}

class NetworkMonitorFailMock: NetworkMonitorProtocol {
    var isConnected: Bool = false
    
    func checkConnection() -> Bool {
        return isConnected
    }
}

class NetworkMonitorSuccessMock: NetworkMonitorProtocol {
    var isConnected: Bool = true
    
    func checkConnection() -> Bool {
        return isConnected
    }
}
