//
//  DataSourceTests.swift
//  Nation
//
//  Created by Anderson Bressane on 06/10/2024.
//
import XCTest
@testable import Nation

class NationDataSourceTests: XCTestCase {
    /*func testParseSuccess() async {
        let dataSource = DataSource(networkClient: MockNetworkClientSuccess())
        
        do {
            let response = try await dataSource.fetchNation(year: 2022)
            
            XCTAssertEqual(response.data.count, 1)
            XCTAssertEqual(response.data.first?.id, "01000US")
            XCTAssertEqual(response.data.first?.name, "United States")
            XCTAssertEqual(response.data.first?.idYear, 2022)
            XCTAssertEqual(response.data.first?.year, "2022")
            XCTAssertEqual(response.data.first?.population, 331097593)
            XCTAssertEqual(response.data.first?.slug, "united-states")
        } catch {
            XCTFail("Extected success, but failed with error: \(error.localizedDescription)")
        }
    }*/
    
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

class MockNetworkClientSuccess: NetworkClientProtocol {
    func fetchData(endPoint: EndpointProtocol) async throws -> Data {
        let mockData = "{{\"data\":[{\"ID Nation\":\"01000US\",\"Nation\":\"United States\",\"ID Year\":2022,\"Year\":\"2022\",\"Population\":331097593,\"Slug Nation\":\"united-states\"}],\"source\":[{\"measures\":[\"Population\"],\"annotations\":{\"source_name\":\"Census Bureau\",\"source_description\":\"The American Community Survey (ACS) is conducted by the US Census and sent to a portion of the population every year.\",\"dataset_name\":\"ACS 5-year Estimate\",\"dataset_link\":\"http://www.census.gov/programs-surveys/acs/\",\"table_id\":\"B01003\",\"topic\":\"Diversity\",\"subtopic\":\"Demographics\"},\"name\":\"acs_yg_total_population_5\",\"substitutions\":[]}]}}".data(using: .utf8)
        
        return mockData!
    }
    
    func fetchData(endPoint: any EndpointProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void) { }
}

class MockNetworkClientFail: NetworkClientProtocol {
    func fetchData(endPoint: EndpointProtocol) async throws -> Data {
        let mockData = "{response: error}".data(using: .utf8)
        
        return mockData!
    }
    
    func fetchData(endPoint: any EndpointProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void) { }
}
