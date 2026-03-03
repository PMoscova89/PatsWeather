//
//  EndPoint.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//


import Foundation

struct Endpoint: Equatable {
    let scheme: String
    let host: String
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]
    let header: [String: String]
    let body: Data?
    
    init(scheme: String = "https",
         host: String,
         path: String,
         method: HTTPMethod = .get,
         queryItems: [URLQueryItem] = [],
         header: [String : String] = [:],
         body: Data? = nil) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.header = header
        self.body = body
    }
}
