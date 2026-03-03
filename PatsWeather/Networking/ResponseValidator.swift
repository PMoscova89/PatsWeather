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
            throw NetworkError.noResponse
        }
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard acceptableStatusCodes.contains(http.statusCode) else {
            throw NetworkError.unnacceptableStatusCode(http.statusCode, data: data)
        }
        guard let data else {
            throw NetworkError.emptyData
        }
        return data
        
    }
}
