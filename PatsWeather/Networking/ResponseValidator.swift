//
//  ResponseValidator.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

protocol ResponseValidating {
    func validate(data: Data?, response: URLResponse?) throws -> Data
}

struct ResponseValidator: ResponseValidating {
    private let acceptableStatusCodes: ClosedRange<Int>
    init(acceptableStatusCodes: ClosedRange<Int> = 200...299) {
        self.acceptableStatusCodes = acceptableStatusCodes
    }
    
    func validate(data: Data?, response: URLResponse?) throws -> Data {
        guard let response else {
            
            if let data, let body = String(data: data, encoding: .utf8) {
                print("OpenWeather error body:", body)
            } else {
                print("OpenWeather error body: <nil or non-utf8>")
            }
            throw NetworkError.noResponse
        }
        
        guard let http = response as? HTTPURLResponse else {
            
            if let data, let body = String(data: data, encoding: .utf8) {
                print("OpenWeather error body:", body)
            } else {
                print("OpenWeather error body: <nil or non-utf8>")
            }
            throw NetworkError.invalidResponse
        }
        
        guard acceptableStatusCodes.contains(http.statusCode) else {
            if let data, let body = String(data: data, encoding: .utf8) {
                print("OpenWeather error body:", body)
            } else {
                print("OpenWeather error body: <nil or non-utf8>")
            }
            
            throw NetworkError.unnacceptableStatusCode(http.statusCode, data: data)
        }
        guard let data else {
            
            if let data, let body = String(data: data, encoding: .utf8) {
                print("OpenWeather error body:", body)
            } else {
                print("OpenWeather error body: <nil or non-utf8>")
            }
            throw NetworkError.emptyData
        }
        return data
        
    }
}
