//
//  URLBuilder.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

protocol URLBuilding {
    func makeURL(from: Endpoint) -> URL?
}

struct URLBuilder: URLBuilding {
    func makeURL(from endpoint: Endpoint) -> URL? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        
        // URLComponents.path should start with "/"
        if endpoint.path.hasPrefix("/") {
            components.path = endpoint.path
        } else {
            components.path = "/" + endpoint.path
        }
        
        components.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems
        return components.url
    }
}
