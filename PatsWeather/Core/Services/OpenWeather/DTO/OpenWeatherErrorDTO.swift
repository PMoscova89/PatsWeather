//
//  OpenWeatherErrorDTO.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

struct OpenWeatherErrorDTO: Decodable, Equatable {
    let cod: Int?
    let message: String?
    let parameters: [String]?
}
