//
//  LocationServiceError.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

enum LocationServiceError: Error, Equatable {
    case notAuthorized
    case unableToDetermineLocation
    case underlying(String)
}
