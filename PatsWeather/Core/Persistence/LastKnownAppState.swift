//
//  LastKnownAppState.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

struct LastKnownAppState: Equatable, Codable {
    let lastSearchedCity: String?
    let lastResolvedCoordinate: Coordinate?
    let lasSuccessfulWeatherFetch: Date?
    
    init(lastSearchedCity: String? = nil,
         lastResolvedCoordinate: Coordinate? = nil,
         lasSuccessfulWeatherFetch: Date? = nil) {
        self.lastSearchedCity = lastSearchedCity
        self.lastResolvedCoordinate = lastResolvedCoordinate
        self.lasSuccessfulWeatherFetch = lasSuccessfulWeatherFetch
    }
}
