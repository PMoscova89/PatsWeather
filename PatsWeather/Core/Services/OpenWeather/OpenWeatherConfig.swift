//
//  OpenWeatherConfig.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

struct OpenWeatherConfig: Equatable {
    let host: String
    let apiKey: String
    let units: Units
    let languageCode: String?
    
    
    enum Units: String, Equatable {
        case standard
        case metric
        case imperial
    }
    
    init(
        host: String = "api.openweathermap.org",
        apiKey: String,
        units: Units = .metric,
        languageCode: String? = nil
    ) {
        self.host = host
        self.apiKey = apiKey
        self.units = units
        self.languageCode = languageCode
    }
}
