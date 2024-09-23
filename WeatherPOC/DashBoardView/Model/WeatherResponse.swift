//
//  WeatherResponse.swift
//  WeatherPOC
//
//  Created by Jatin Patel on 8/21/24.
//

import Foundation

struct WeatherData: Codable, Equatable {
    
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Double?
    let wind: Wind?
    let snow: Snow?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
    
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.coord == rhs.coord &&
                       lhs.weather == rhs.weather &&
                       lhs.base == rhs.base &&
                       lhs.main == rhs.main &&
                       lhs.visibility == rhs.visibility &&
                       lhs.wind == rhs.wind &&
                       lhs.snow == rhs.snow &&
                       lhs.clouds == rhs.clouds &&
                       lhs.dt == rhs.dt &&
                       lhs.sys == rhs.sys &&
                       lhs.timezone == rhs.timezone &&
                       lhs.id == rhs.id &&
                       lhs.name == rhs.name &&
                       lhs.cod == rhs.cod
    }
}

struct Clouds: Codable, Equatable {
    let all: Int?
}

struct Coord: Codable, Equatable {
    let lon, lat: Double?
}

struct Main: Codable, Equatable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure: Double?
    let humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct Snow: Codable, Equatable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

struct Sys: Codable, Equatable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

struct Weather: Codable, Equatable {
    let id: Int?
    let main, description, icon: String?
}

struct Wind: Codable, Equatable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}


extension WeatherData {
    static func mockWeatherData() -> WeatherData {
        // Create and return a mock WeatherData object
        return WeatherData(
            coord: Coord(lon: -0.1276, lat: 51.5074), // Example coordinates for London
            weather: [
                Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")
            ],
            base: "stations",
            main: Main(
                temp: 15.0,
                feelsLike: 14.0,
                tempMin: 13.0,
                tempMax: 17.0,
                pressure: 1013.0,
                humidity: 72
            ),
            visibility: 10000.0, // Visibility in meters
            wind: Wind(
                speed: 3.5,
                deg: 210,
                gust: 5.0
            ),
            snow: Snow(the1H: 0.0), // No snow
            clouds: Clouds(all: 5), // Few clouds
            dt: 1692578400, // Example timestamp
            sys: Sys(
                type: 1,
                id: 1414,
                country: "GB",
                sunrise: 1692562210,
                sunset: 1692618090
            ),
            timezone: 3600, // GMT+1
            id: 2643743, // London city ID
            name: "London",
            cod: 200 // HTTP status code for OK
        )
    }
}

