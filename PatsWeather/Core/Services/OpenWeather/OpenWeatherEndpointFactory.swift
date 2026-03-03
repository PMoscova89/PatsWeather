//
//  OpenWeatherEndpointFactory.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

protocol OpenWeatherEndpointBuilding {
    func makeGeocodingEndpoint(city: String, limit: Int) -> Endpoint
    func makeOneCallEndpoint(coordinate: Coordinate, excludeParts: [String]) -> Endpoint
}

struct OpenWeatherEndpointFactory: OpenWeatherEndpointBuilding {
    private let config: OpenWeatherConfig
    
    init(config: OpenWeatherConfig) {
        self.config = config
    }
    
    func makeGeocodingEndpoint(city: String, limit: Int) -> Endpoint {
        let quereyItems: [URLQueryItem] = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "appid", value: config.apiKey)
        ]
        
        return Endpoint(host: config.host,
                        path: "/geo/1.0/direct",
                        method: .get,
                        queryItems: quereyItems
            )
    }
    
    func makeOneCallEndpoint(coordinate: Coordinate, excludeParts: [String] = []) -> Endpoint {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "lat", value: String(coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(coordinate.longitude)),
            URLQueryItem(name: "appid", value: config.apiKey),
            URLQueryItem(name: "units", value: config.units.rawValue)
        ]
        
        if let languageCode = config.languageCode, !languageCode.isEmpty {
            queryItems.append(URLQueryItem(name: "lang", value: languageCode))
        }
        if !excludeParts.isEmpty {
            let value = excludeParts.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "exclude", value: value))
        }
        return Endpoint(
            host: config.host,
            path: "data/3.0/onecall",
            method: .get,
            queryItems: queryItems
        )
    }
}
