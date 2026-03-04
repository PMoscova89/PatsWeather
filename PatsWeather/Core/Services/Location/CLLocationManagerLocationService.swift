//
//  CLLocationManagerLocationService.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import CoreLocation
import Foundation

final class CLLocationManagerLocationService: NSObject, LocationServiceType {
    private let manager: CLLocationManager
    private var continuation: CheckedContinuation<Coordinate, Error>?
    
    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
    }
    
    func currentAuthorizationStatus() -> LocationAuthorizationStatus {
        let status = manager.authorizationStatus
        
        switch status {
            case .notDetermined:
                return .notDetermined
            case .restricted:
                return .restricted
            case .denied:
                return .denied
            case .authorizedAlways:
                return .authorized
            case .authorizedWhenInUse:
                return .authorized
            @unknown default:
                return .denied
        }
    }
    
    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func fetchCurrentCoordinate() async throws -> Coordinate {
        let status = currentAuthorizationStatus()
        guard status == .authorized else {
            throw LocationServiceError.notAuthorized
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            self.manager.requestLocation()
        }
    }
}

extension CLLocationManagerLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            continuation?.resume(throwing: LocationServiceError.unableToDetermineLocation)
            continuation = nil
            return
        }
        
        let coordinate = Coordinate(
            latitude: first.coordinate.latitude,
            longitude: first.coordinate.longitude
        )
        continuation?.resume(returning: coordinate)
        continuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        continuation?.resume(throwing: LocationServiceError.underlying(error.localizedDescription))
        continuation = nil
    }
}
