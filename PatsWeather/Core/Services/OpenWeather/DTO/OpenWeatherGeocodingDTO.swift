//
//  Untitled.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

struct OpenWeatherGeocodingDTO: Decodable, Equatable {
    let name: String?
    let lat: Double
    let lon: Double
    let country: String?
    let state: String?
}
