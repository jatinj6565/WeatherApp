//
//  DashboardViewModelTests.swift
//  WeatherPOCTests
//
//  Created by Jatin Patel on 8/21/24.
//

import XCTest
import Combine
import CoreLocation
@testable import WeatherPOC

final class DashboardViewModelTests: XCTestCase {
    private var viewModel: DashboardViewModel!
    private var mockNetworkManager: MockNetworkManager!
    private var mockUserDefaults: MockUserDefaults!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockUserDefaults = MockUserDefaults(suiteName: "TestDefaults")
        viewModel = DashboardViewModel(networkManager: mockNetworkManager)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        mockUserDefaults = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetWeatherSuccess() async {
        // Given
        mockNetworkManager.mockWeatherData = WeatherData.mockWeatherData() // Mocked WeatherData
        
        // When
        await viewModel.getWeather(lat: 40.7128, long: -74.0060)  // Coordinates for New York City
        
        // Then
        XCTAssertNotNil(viewModel.weatherResponse)
        XCTAssertEqual(viewModel.weatherResponse, mockNetworkManager.mockWeatherData)
    }
    
    func testGetWeatherFailure() async {
        // Given
        mockNetworkManager.shouldReturnError = true
        
        // When
        await viewModel.getWeather(lat: 44.34, long: 10.99)
        
        // Then
        XCTAssertNil(viewModel.weatherResponse)
    }
    
    func testGetSelectedLocation_WithSavedLocation() async {
            // Given
        let savedLocation = SearchResponse.mockSearchResponse() // Mumbai
            let encoder = JSONEncoder()
            let savedData = try! encoder.encode(savedLocation)
            AppUserDefaults.set(savedData, forKey: UserDefaultSelectedLocation)
            
            mockNetworkManager.mockWeatherData = WeatherData.mockWeatherData()

            // When
            await viewModel.getSelectedLocation(currentLocation: nil)

            // Then
            XCTAssertEqual(viewModel.weatherResponse?.coord?.lat, savedLocation.lat)
            XCTAssertEqual(viewModel.weatherResponse?.coord?.lon, savedLocation.lon)
        }

        func testGetSelectedLocation_WithCurrentLocation() async {
            // Given
            let currentLocation = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1276) // Los Angeles
            mockNetworkManager.mockWeatherData = WeatherData.mockWeatherData()

            // When
            await viewModel.getSelectedLocation(currentLocation: currentLocation)

            // Then
            XCTAssertEqual(viewModel.weatherResponse?.coord?.lat, currentLocation.latitude)
            XCTAssertEqual(viewModel.weatherResponse?.coord?.lon, currentLocation.longitude)
        }

        func testGetSelectedLocation_WithNoSavedLocationAndNoCurrentLocation() async {
            // Given
            AppUserDefaults.removeObject(forKey: UserDefaultSelectedLocation)
            let defaultLatitude = 35.7327
            let defaultLongitude = 78.8503
            mockNetworkManager.mockWeatherData = WeatherData.mockWeatherData()

            // When
            await viewModel.getSelectedLocation(currentLocation: nil)

            // Then
            XCTAssertEqual(DefaultLatitude, defaultLatitude)
            XCTAssertEqual(DefaultLongitude, defaultLongitude)
        }
}
