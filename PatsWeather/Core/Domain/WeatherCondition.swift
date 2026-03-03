//
//  WeatherCondition.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//


import Foundation

struct WeatherCondition: Equatable {
    let id: Int
    let main: String
    let detail: String
    let iconID: String
    
    init(id: Int, main: String, detail: String, iconID: String) {
        self.id = id
        self.main = main
        self.detail = detail
        self.iconID = iconID
    }
}

extension WeatherCondition {
    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(iconID)@2x.png")
    }
}
