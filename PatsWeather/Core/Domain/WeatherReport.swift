//
//  WeatherReport.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import Foundation

struct WeatherReport: Equatable {
    let location: LocationDescriptor
    let condition: WeatherCondition
    let temperature: Temperature
    let wind: Wind?
    let humidityPercent: Int?
    let pressureHPa: Int?
    let observationDate: Date
    
    init(location: LocationDescriptor,
         condition: WeatherCondition,
         temperature: Temperature,
         wind: Wind? = nil,
         humidityPercent: Int? = nil,
         pressureHPa: Int? = nil,
         observationDate: Date = Date()) {
        self.location = location
        self.condition = condition
        self.temperature = temperature
        self.wind = wind
        self.humidityPercent = humidityPercent
        self.pressureHPa = pressureHPa
        self.observationDate = observationDate
    }
}
