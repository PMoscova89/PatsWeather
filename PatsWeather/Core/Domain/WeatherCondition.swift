//
//  WeatherCondition.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//


import Foundation

struct WeatherCondition: Equatable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
    
    init(
        id: Int? = nil,
        main: String? = nil,
        description: String? = nil,
        icon: String? = nil
    ) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}
