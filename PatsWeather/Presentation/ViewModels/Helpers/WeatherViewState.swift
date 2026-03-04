//
//  WeatherViewState.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

enum WeatherStatus: Equatable {
    case idle
    case loading
    case success(report: WeatherReport, locationName: String)
    case failed(message: String)
}

enum IconStatus: Equatable {
    case idle
    case loading(code: String)
    case success(code: String)
    case failed(code: String)
}
