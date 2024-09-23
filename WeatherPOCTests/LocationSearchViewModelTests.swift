//
//  LocationSearchViewModelTests.swift
//  WeatherPOCTests
//
//  Created by Jatin Patel on 9/22/24.
//

import XCTest
import Combine
@testable import WeatherPOC

final class LocationSearchViewModelTests: XCTestCase {
    
    private var viewModel: LocationSearchViewModel!
    private var mockNetworkManager: MockNetworkManager!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = LocationSearchViewModel(networkManager: mockNetworkManager)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSetSelectedLocation() {
            // Given
        let searchResponse = SearchResponse.mockSearchResponse()

            // When
            viewModel.setSelectedLocation(selectedSearchData: searchResponse)

            // Then
            XCTAssertEqual(viewModel.selectedSearchData?.name, "London")
            XCTAssertEqual(viewModel.selectedSearchData?.country, "GB")
        }
    
    func testFlagFunction() {
            // Given
            let country = "GB"
            
            // When
            let flag = viewModel.flag(country: country)

            // Then
            XCTAssertEqual(flag, "🇬🇧") // The expected flag for England
        }
    
    func testSearchCitiesSuccess() async {
        // Given
        let mockResponse = [
            SearchResponse.mockSearchResponse()
        ]
        mockNetworkManager.mockSearchResponse = mockResponse

        // When
        await viewModel.searchCities("London")

        // Then
        XCTAssertEqual(viewModel.searchData.count, 1)
        XCTAssertEqual(viewModel.searchData[0].name, "London")
    }
    
    func testSearchCitiesFailure() async {
        // Given
        mockNetworkManager.shouldReturnError = true

        // When
        await viewModel.searchCities("UnknownCity")

        // Then
        XCTAssertEqual(viewModel.searchData.count, 0) // No data should be returned
    }
}
