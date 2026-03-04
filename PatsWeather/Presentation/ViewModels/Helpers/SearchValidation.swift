//
//  SearchValidation.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

enum SearchStatus: Equatable {
    case idle
    case validating
    case searching
    case failed(message: String)
    case succeeded(city: String, coordinate: Coordinate)
}
