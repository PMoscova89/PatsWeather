//
//  MappingTests.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/11/26.
//

import Testing
import CoreLocation
@testable import PatsWeather

@Suite("OpenWeather DTO Mapping")
struct OpenWeatherDTOMappingTests {
    @Test("Decodes OpenWeatherCurrentWeatherDTO and maps to WeatherReport")
    func decodesAndMapsCurrentWeatherDTO() throws {
        // Given: a minimal current weather JSON payload from OpenWeather
        let json = """
        {
          "name": "Cupertino",
          "dt": 1700000000,
          "timezone": -25200,
          "weather": [
            { "id": 800, "main": "Clear", "description": "clear sky", "icon": "01d" }
          ],
          "main": {
            "temp": 23.5,
            "feels_like": 24.0,
            "temp_min": 20.0,
            "temp_max": 26.0,
            "pressure": 1013,
            "humidity": 40
          },
          "wind": { "speed": 3.6, "deg": 180 },
          "sys": { "country": "US", "sunrise": 1700000100, "sunset": 1700040000 }
        }
        """.data(using: .utf8)!
        
        // When: decode into DTO
        let decoder = JSONDecoder()
        let dto = try decoder.decode(OpenWeatherCurrentWeatherDTO.self, from: json)
        
        // And: map to domain
        let mapper = OpenWeatherOneCallMapper()
        let report = try #require(mapper.mapToWeatherReport(dto))
        
        // Then: verify essential fields carried over
        #expect(report.timezone == "Cupertino")
        #expect(report.current.temperature == 23.5)
        #expect(report.current.humidity == 40)
        #expect(report.current.windSpeed == 3.6)
        #expect(report.current.condition.id == 800)
        #expect(report.current.condition.main == "Clear")
        #expect(report.current.condition.icon == "01d")
    }
    
    @Test("Maps OpenWeatherOneCallDTO to WeatherReport with arrays and alerts")
    func mapsOneCallDTOToWeatherReport() {
        // Given: a handcrafted DTO resembling One Call response
        let dto = OpenWeatherOneCallDTO(
            lat: 37.3349,
            lon: -122.0090,
            timezone: "America/Los_Angeles",
            timezoneOffset: -25200,
            current: .init(
                dt: 1700000000,
                sunrise: 1700000100,
                sunset: 1700040000,
                temp: 20.0,
                feelsLike: 19.5,
                pressure: 1013,
                humidity: 50,
                dewPoint: 10.0,
                uvi: 5.0,
                clouds: 0,
                visibility: 10000,
                windSpeed: 2.0,
                windGust: 3.0,
                windDeg: 90,
                rain: nil,
                snow: nil,
                weather: [.init(id: 801, main: "Clouds", description: "few clouds", icon: "02d")]
            ),
            minutely: nil,
            hourly: [
                .init(
                    dt: 1700003600,
                    temp: 21.0,
                    feelsLike: 21.0,
                    pressure: 1012,
                    humidity: 48,
                    dewPoint: 9.0,
                    uvi: 4.5,
                    clouds: 10,
                    visibility: 10000,
                    windSpeed: 2.2,
                    windGust: 3.1,
                    windDeg: 100,
                    pop: 0.1,
                    rain: nil,
                    snow: nil,
                    weather: [.init(id: 800, main: "Clear", description: "clear sky", icon: "01d")]
                )
            ],
            daily: [
                .init(
                    dt: 1700000000,
                    sunrise: 1700000100,
                    sunset: 1700040000,
                    moonrise: nil,
                    moonset: nil,
                    moonPhase: nil,
                    summary: "Nice day",
                    temp: .init(morn: 15, day: 22, eve: 18, night: 12, min: 12, max: 24),
                    feelsLike: .init(morn: 15, day: 22, eve: 18, night: 12),
                    pressure: 1013,
                    humidity: 45,
                    dewPoint: 9.0,
                    windSpeed: 2.4,
                    windGust: 3.5,
                    windDeg: 110,
                    clouds: 5,
                    uvi: 5.5,
                    pop: 0.0,
                    rain: nil,
                    snow: nil,
                    weather: [.init(id: 801, main: "Clouds", description: "few clouds", icon: "02d")]
                )
            ],
            alerts: [
                .init(
                    senderName: "NWS",
                    event: "Test Alert",
                    start: 1700001000,
                    end: 1700004600,
                    description: "This is a test alert",
                    tags: ["test"]
                )
            ]
        )
        
        // When: map
        let mapper = OpenWeatherOneCallMapper()
        let report = try! #require(mapper.mapToWeatherReport(dto))
        
        // Then
        #expect(report.timezone == "America/Los_Angeles")
        #expect(!report.hourly.isEmpty)
        #expect(!report.daily.isEmpty)
        #expect(!report.alerts.isEmpty)
        #expect(report.current.condition.id == 801)
    }
}

