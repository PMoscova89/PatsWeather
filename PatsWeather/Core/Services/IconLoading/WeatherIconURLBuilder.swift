//
//  WeatherIconURLBuilder.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

//https://openweathermap.org/img/wn/{icon}@2x.png

import Foundation

protocol WeatherIconURLBuilding {
    func makeIconURL(for iconCode: String) -> URL?
}

struct WeatherIconURLBuilder: WeatherIconURLBuilding {
    private let baseURLString: String
    
    init(baseURLString: String = "https://openweathermap.org/img/wn/") {
        self.baseURLString = baseURLString
    }
    
    func makeIconURL(for iconCode: String) -> URL? {
        let fullPath = "\(baseURLString)\(iconCode)@2x.png"
        return URL(string: fullPath)
    }
}
