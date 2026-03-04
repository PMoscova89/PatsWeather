//
//  LocationServiceType.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

protocol LocationServiceType {
    func currentAuthorizationStatus() -> LocationAuthorizationStatus
    func requestWhenInUseAuthorization()
    func fetchCurrentCoordinate() async throws -> Coordinate
}
