//
//  DataSourceTests.swift
//  Nation
//
//  Created by Anderson Bressane on 06/10/2024.
//
import XCTest
@testable import Nation

class DataSourceTests: XCTestCase {
    func testParseError() async {
        let dataSource = DataSource(networkClient: MockNetworkClientFail())
        
        do {
            _ = try await dataSource.fetchNation(year: 2022)
            XCTFail("Expected failure, but succeeded")
        } catch {
            XCTAssertEqual(error as! DataSourceError, DataSourceError.parsingError)
        }
    }
}

class MockNetworkClientFail: NetworkClientProtocol {
    func fetchData(endPoint: EndpointProtocol) async throws -> Data {
        let mockData = "{response: error}".data(using: .utf8)
        
        return mockData!
    }
    
    func fetchData(endPoint: any EndpointProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void) { }
}
