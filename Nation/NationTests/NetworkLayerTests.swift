//
//  NetworkLayerTests.swift
//  Nation
//
//  Created by Anderson Bressane on 05/10/2024.
//

import XCTest
@testable import Nation

class NetworkLayerTests: XCTestCase {
    var networkMonitor: NetworkMonitorProtocol!
    var networkClient: NetworkClient!
    var session: URLSession!
    
    override func setUp() {
        networkMonitor = MockNetworkMonitorSuccess()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        
        networkClient = NetworkClient(session: session, networkMonitor: networkMonitor)
    }
    
    override func tearDown() {
        networkMonitor = nil
        networkClient = nil
        session = nil
        
        super.tearDown()
    }
    
    func testConnectionFail() {
        let networkMonitor = MockNetworkMonitorFail()
        XCTAssertFalse(networkMonitor.checkConnection())
    }
    
    func testConnectionSuccess() {
        let networkMonitor = MockNetworkMonitorSuccess()
        XCTAssertTrue(networkMonitor.checkConnection())
    }
    
    func testConnectivityFail() {
        let expectation = self.expectation(description: "Get connection response")
            
        let failNetworkClient = NetworkClient(networkMonitor: MockNetworkMonitorFail())
        
        failNetworkClient.fetchData(endPoint: Endpoint(action: .getNation)) { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure .noConnection, but got isConnected")
            case .failure(let error):
                XCTAssertEqual(error, .noConnection)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testConnectivitySuccess() {
        let expectation = self.expectation(description: "Get connection response")
        
        let successNetworkClient = NetworkClient(networkMonitor: MockNetworkMonitorSuccess())
        
        successNetworkClient.fetchData(endPoint: Endpoint(action: .getNation)) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                XCTFail("Expected success isConnected, but got noConnection")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testBadURL() {
        let networkClient = NetworkClient(networkMonitor: MockNetworkMonitorSuccess())
        
        networkClient.fetchData(endPoint: Endpoint(action: .none)) { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertEqual(error, .badURL)
            }
        }
    }
    
    func testInvalidHTTPResponse() {
        let expectation = self.expectation(description: "Get http responseCode")
        
        MockURLProtocol.testResponse = HTTPURLResponse(url: Endpoint(action: .getNation).url!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        networkClient.fetchData(endPoint: Endpoint(action: .getNation)) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .httpError(404))
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    /*func testValidHTTPResponse() async {
        MockURLProtocol.testResponse = HTTPURLResponse(url: Endpoint(action: .getNation).url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await networkClient.fetchData(endPoint: Endpoint(action: .getNation))
        } catch {
            XCTFail("Expected success \(error.localizedDescription)")
        }
    }*/
    
    func testNoDataResponse() {
        let expectation = self.expectation(description: "Get response data")
        
        MockURLProtocol.testResponse = HTTPURLResponse(url: Endpoint(action: .getNation).url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        MockURLProtocol.testData = nil
        
        networkClient.fetchData(endPoint: Endpoint(action: .getNation)) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .noData)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testDadaResponse() {
        let expectation = self.expectation(description: "Get response data")
        
        MockURLProtocol.testResponse = HTTPURLResponse(url: Endpoint(action: .getNation).url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let mockData = "{sucess: true}".data(using: .utf8)
        
        MockURLProtocol.testData = mockData
        
        networkClient.fetchData(endPoint: Endpoint(action: .getNation)) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, mockData)
            case .failure:
                XCTFail("Expected failure, but got success")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}

class MockURLProtocol: URLProtocol {
    static var testResponse: HTTPURLResponse?
    static var testData: Data?
    static var testError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let testError = MockURLProtocol.testError {
            self.client?.urlProtocol(self, didFailWithError: testError)
        } else {
            if let testResponse = MockURLProtocol.testResponse {
                self.client?.urlProtocol(self, didReceive: testResponse, cacheStoragePolicy: .notAllowed)
            }
            if let testData = MockURLProtocol.testData {
                self.client?.urlProtocol(self, didLoad: testData)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() { }
}

class MockNetworkMonitorFail: NetworkMonitorProtocol {
    var isConnected: Bool = false
    
    func checkConnection() -> Bool {
        return isConnected
    }
}

class MockNetworkMonitorSuccess: NetworkMonitorProtocol {
    var isConnected: Bool = true
    
    func checkConnection() -> Bool {
        return isConnected
    }
}
