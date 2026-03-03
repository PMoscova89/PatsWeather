//
//  OpenWeatherOneCallDTO.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

struct OpenWeatherOneCallDTO: Decodable, Equatable {
    let lat: Double?
    let lon: Double?
    let timezone: String?
    let timezoneOffset: Int?
    
    let current: CurrentDTO?
    let minutely: [MinutelyDTO]?
    let hourly: [HourlyDTO]?
    let daily: [DailyDTO]?
    let alerts: [AlertDTO]?
    struct CurrentDTO: Decodable, Equatable {
        let dt: Int?
        let sunrise: Int?
        let sunset: Int?
        let temp: Double?
        let feelsLike: Double?
        let pressure: Int?
        let humidity: Int?
        let dewPoint: Double?
        let uvi: Double?
        let clouds: Int?
        let visibility: Int?
        let windSpeed: Double?
        let windGust: Double?
        let windDeg: Int?
        
        let rain: PrecipitationDTO?
        let snow: PrecipitationDTO?
        let weather: [WeatherDTO]?
        
        enum CodingKeys: String, CodingKey {
            case dt
            case sunrise
            case sunset
            case temp
            case feelsLike = "feels_like"
            case pressure
            case humidity
            case dewPoint = "dew_point"
            case uvi
            case clouds
            case visibility
            case windSpeed = "wind_speed"
            case windGust = "wind_gust"
            case windDeg = "wind_deg"
            case rain
            case snow
            case weather
        }
    }
    
    struct MinutelyDTO: Decodable, Equatable {
        let dt: Int?
        let precipitation: Double?
    }
    
    struct HourlyDTO: Decodable, Equatable {
        let dt: Int?
        let temp: Double?
        let feelsLike: Double?
        let pressure: Int?
        let humidity: Int?
        let dewPoint: Double?
        let uvi: Double?
        let clouds: Int?
        let visibility: Int?
        let windSpeed: Double?
        let windGust: Double?
        let windDeg: Int?
        let pop: Double?
        
        let rain: PrecipitationDTO?
        let snow: PrecipitationDTO?
        let weather: [WeatherDTO]?
        
        enum CodingKeys: String, CodingKey {
            case dt
            case temp
            case feelsLike = "feels_like"
            case pressure
            case humidity
            case dewPoint = "dew_point"
            case uvi
            case clouds
            case visibility
            case windSpeed = "wind_speed"
            case windGust = "wind_gust"
            case windDeg = "wind_deg"
            case pop
            case rain
            case snow
            case weather
        }
    }
    
    struct DailyDTO: Decodable, Equatable {
        let dt: Int?
        let sunrise: Int?
        let sunset: Int?
        let moonrise: Int?
        let moonset: Int?
        let moonPhase: Double?
        let summary: String?
        
        let temp: DailyTempDTO?
        let feelsLike: DailyFeelsLikeDTO?
        
        let pressure: Int?
        let humidity: Int?
        let dewPoint: Double?
        let windSpeed: Double?
        let windGust: Double?
        let windDeg: Int?
        let clouds: Int?
        let uvi: Double?
        let pop: Double?
        let rain: Double?
        let snow: Double?
        let weather: [WeatherDTO]?
        
        enum CodingKeys: String, CodingKey {
            case dt
            case sunrise
            case sunset
            case moonrise
            case moonset
            case moonPhase = "moon_phase"
            case summary
            case temp
            case feelsLike = "feels_like"
            case pressure
            case humidity
            case dewPoint = "dew_point"
            case windSpeed = "wind_speed"
            case windGust = "wind_gust"
            case windDeg = "wind_deg"
            case clouds
            case uvi
            case pop
            case rain
            case snow
            case weather
        }
    }
    
    struct DailyTempDTO: Decodable, Equatable {
        let morn: Double?
        let day: Double?
        let eve: Double?
        let night: Double?
        let min: Double?
        let max: Double?
    }
    
    struct DailyFeelsLikeDTO: Decodable, Equatable {
        let morn: Double?
        let day: Double?
        let eve: Double?
        let night: Double?
    }
    
    struct AlertDTO: Decodable, Equatable {
        let senderName: String?
        let event: String?
        let start: Int?
        let end: Int?
        let description: String?
        let tags: [String]?
        
        enum CodingKeys: String, CodingKey {
            case senderName = "sender_name"
            case event
            case start
            case end
            case description
            case tags
        }
    }
    
    struct WeatherDTO: Decodable, Equatable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    
    struct PrecipitationDTO: Decodable, Equatable {
        let oneHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }
}
