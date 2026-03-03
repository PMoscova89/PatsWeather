//
//  NetworkError.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//
import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case transportError(String)
    case noResponse
    case invalidResponse
    case unnacceptableStatusCode(Int, data:Data?)
    case emptyData
    case decodingFailed(String)
    case cancelled
    
    static func map(_ error: Error) -> NetworkError {
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain, nsError.code == NSURLErrorCancelled {
            return .cancelled
        }
        
        return .transportError(error.localizedDescription)
    }
}
