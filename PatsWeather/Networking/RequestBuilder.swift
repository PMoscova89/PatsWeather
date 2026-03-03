//
//  RequestBuilder.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

protocol RequestBuilding {
    func makeRequest(from endpoint: Endpoint) throws -> URLRequest
}

struct RequestBuilder: RequestBuilding {
    private let urlBuilder: URLBuilding
    private let timeOut: TimeInterval
    
    init(urlBuilder: URLBuilding, timeOut: TimeInterval = 30.0) {
        self.urlBuilder = urlBuilder
        self.timeOut = timeOut
    }
    
    func makeRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let url = urlBuilder.makeURL(from: endpoint) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url, timeoutInterval: timeOut)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        endpoint.header.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
