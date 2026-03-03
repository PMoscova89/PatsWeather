//
//  HTTPMethod.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//


import Foundation

enum HTTPMethod: String, Equatable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
