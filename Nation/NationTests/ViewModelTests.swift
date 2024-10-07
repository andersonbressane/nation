//
//  ViewModelTests.swift
//  Nation
//
//  Created by Anderson Bressane on 07/10/2024.
//
import XCTest
@testable import Nation

class ViewModelTests: XCTestCase {
    func testNoData() async {
        let viewModel = ViewModel(dataSource: MockDataSourceFail())
        
        do {
            try await viewModel.fetchData()
            
            XCTFail("This should fail")
        } catch {
            XCTAssertEqual(error as! ViewModelProtocolError, ViewModelProtocolError.noData)
        }
    }
}

class MockDataSourceFail: DataSourceProtocol {
    func fetchNation(year: Int?) async throws -> NationResponse {
        return NationResponse(data: [])
    }
    
    func fetchStates(year: Int?) async throws -> StateResponse {
        return StateResponse(data: [])
    }
}
