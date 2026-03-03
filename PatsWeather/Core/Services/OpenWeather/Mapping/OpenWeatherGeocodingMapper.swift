//
//  OpenWeatherGeocodingMapper.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

protocol OpenWeatherGeocodingMapping {
    func mapToCoordinatoe(_ dto: OpenWeatherGeocodingDTO) -> Coordinate
}

struct OpenWeatherGeocodingMapper: OpenWeatherGeocodingMapping  {
    func mapToCoordinatoe(_ dto: OpenWeatherGeocodingDTO) -> Coordinate {
        Coordinate(latitude: dto.lat, longitude: dto.lon)
    }
}
