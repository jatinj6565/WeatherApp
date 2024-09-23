//
//  MockNetworkManager.swift
//  WeatherPOCTests
//
//  Created by Jatin Patel on 8/21/24.
//

import Foundation
import Combine
@testable import WeatherPOC

class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var mockWeatherData: WeatherData?
    var mockSearchResponse: [SearchResponse] = []
    
    func makeNetworkCall<T>(endpoint: Endpoint, httpMethod: HttpMethods, parameters: [String: Any], type: T.Type) async -> Future<T, Error> where T : Decodable {
        return Future<T, Error> { promise in
            if self.shouldReturnError {
                promise(.failure(NetworkError.responseError))
            } else if let weatherData = self.mockWeatherData as? T {
                promise(.success(weatherData))
            } else if let searchResponse = self.mockSearchResponse as? T {
                promise(.success(searchResponse))
            }
            else {
                promise(.failure(NetworkError.unknown))
            }
        }
    }
}
