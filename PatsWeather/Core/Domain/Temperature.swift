//
//  Temperature.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

struct Temperature : Equatable {
    let current: Double
    let feelsLike: Double?
    let min: Double?
    let max: Double?
    let units: WeatherUnits
    
    init(current: Double,
         feelsLike: Double? = nil,
         min: Double? = nil,
         max: Double? = nil,
         units: WeatherUnits) {
        self.current = current
        self.feelsLike = feelsLike
        self.min = min
        self.max = max
        self.units = units
    }
}

extension Temperature {
    var displaySymbol: String {
        switch units {
            case .imperial: return "°F"
            case .metric: return "°C"
        }
    }
}
