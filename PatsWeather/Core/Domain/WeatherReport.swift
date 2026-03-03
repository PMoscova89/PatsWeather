//
//  WeatherReport.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//
import Foundation

struct WeatherReport: Equatable {
    let timezone: String
    let current: CurrentWeather
    let hourly: [HourlyForecast]
    let daily: [DailyForecast]
    let alerts: [WeatherAlert]
    
    struct CurrentWeather: Equatable {
        let timestamp: Date
        let sunrise: Date?
        let sunset: Date?
        let temperature: Double
        let feelsLike: Double?
        let humidity: Int?
        let windSpeed: Double?
        let condition: WeatherCondition
    }
    
    struct HourlyForecast: Equatable {
        let timestamp: Date
        let temperature: Double?
        let precipitationChance: Double?
        let condition: WeatherCondition
    }
    
    struct DailyForecast: Equatable {
        let timestamp: Date
        let sunrise: Date?
        let sunset: Date?
        let minTemp: Double?
        let maxTemp: Double?
        let condition: WeatherCondition
        let summary: String?
    }
    
    struct WeatherAlert: Equatable {
        let senderName: String?
        let event: String?
        let start: Date?
        let end: Date?
        let description: String?
        let tags: [String]
    }
}
