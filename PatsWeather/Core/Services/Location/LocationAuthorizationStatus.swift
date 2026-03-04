//
//  LocationAuthorizationStatus.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

enum LocationAuthorizationStatus: Equatable {
    case notDetermined
    case denied
    case restricted
    case authorized
}
