//
//  AppConfiguration.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import Foundation
enum AppConfiguration {
    static var openWeatherApiKey: String {
        let key = Bundle.main.object(forInfoDictionaryKey: "OPENWEATHER_API_KEY") as? String ?? ""
        print("OpenWeather key starts with:", String(key.prefix(8)))
        return key.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
