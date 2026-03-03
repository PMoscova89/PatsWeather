//
//  Wind.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//
import Foundation

struct Wind: Equatable {
    let speed: Double
    let directionDegrees: Double?
    let units: WeatherUnits
    
    init(speed: Double,
         directionDegrees: Double?,
         units: WeatherUnits) {
        self.speed = speed
        self.directionDegrees = directionDegrees
        self.units = units
    }
}

extension Wind {
    var speedUnitLabel: String {
        switch units {
            case .imperial: return "mph"
            case .metric: return "m/s"
        }
    }
}
