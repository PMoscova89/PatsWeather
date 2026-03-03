//
//  WeatherUnits.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import Foundation
enum WeatherUnits: Equatable {
    case imperial
    case metric
}

extension WeatherUnits {
    var openWeatherQueryValue: String {
        switch self{
            case .imperial: return "imperial"
            case .metric: return "metric"
        }
    }
}
