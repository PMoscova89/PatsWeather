//
//  TestDoubles.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/11/26.
//

import Foundation
import CoreLocation
@testable import PatsWeather
import UIKit


// MARK: - Test Double: MockCLLocationManager

final class MockCLLocationManager: CLLocationManager {
    // Keep a separate delegate reference that we control
    weak var mockDelegate: CLLocationManagerDelegate?
    
    // Stubs
    var stubAuthorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse
    
    // Spies
    private(set) var didRequestWhenInUseAuthorization = false
    private(set) var didRequestLocation = false
    
    // Override delegate to use our mockDelegate
    override var delegate: CLLocationManagerDelegate? {
        get { mockDelegate }
        set { mockDelegate = newValue }
    }
    
    override var authorizationStatus: CLAuthorizationStatus {
        stubAuthorizationStatus
    }
    
    override func requestWhenInUseAuthorization() {
        didRequestWhenInUseAuthorization = true
    }
    
    override func requestLocation() {
        didRequestLocation = true
    }
    
    // MARK: - Helpers to drive delegate callbacks
    func simulateUpdate(latitude: Double, longitude: Double) {
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        mockDelegate?.locationManager?(self, didUpdateLocations: [loc])
    }
    
    func simulateEmptyUpdate() {
        mockDelegate?.locationManager?(self, didUpdateLocations: [])
    }
    
    func simulateFailure(_ error: Error) {
        mockDelegate?.locationManager?(self, didFailWithError: error)
    }
}

// MARK: - WeatherServiceType Mock/Stub
final class MockWeatherService: WeatherServiceType {
    private(set) var fetchWeatherCalled = false
    private(set) var receivedCoordinate: Coordinate?
    private(set) var receivedUnits: String?
    private(set) var receivedLang: String?
    var nextResult: Result<WeatherReport, Error> = .failure(NSError(domain: "", code: -1))

    func stubSuccess(_ report: WeatherReport) { nextResult = .success(report) }
    func stubFailure(_ error: Error = NSError(domain: "", code: -1)) { nextResult = .failure(error) }
    
    func fetchWeather(for coordinate: Coordinate, units: String, lang: String) async throws -> WeatherReport {
        fetchWeatherCalled = true
        receivedCoordinate = coordinate
        receivedUnits = units
        receivedLang = lang
        switch nextResult {
            case .success(let report): return report
            case .failure(let error): throw error
        }
    }
}

// MARK: - GeocodingServiceType Mock/Stub
final class MockGeocodingService: GeocodingServiceType {
    private(set) var fetchCoordinateCalled = false
    private(set) var receivedCity: String?
    var nextResult: Result<Coordinate, Error> = .failure(NSError(domain: "", code: -1))
    
    func stubSuccess(_ coord: Coordinate) { nextResult = .success(coord) }
    func stubFailure(_ error: Error = NSError(domain: "", code: -1)) { nextResult = .failure(error) }
    
    func fetchCoordinate(for city: String) async throws -> Coordinate {
        fetchCoordinateCalled = true
        receivedCity = city
        switch nextResult {
            case .success(let coord): return coord
            case .failure(let error): throw error
        }
    }
}

// MARK: - LocationServiceType Spy
final class SpyLocationService: LocationServiceType {
    private(set) var currentAuthorizationStatusCalled = false
    private(set) var requestWhenInUseAuthorizationCalled = false
    private(set) var fetchCurrentCoordinateCalled = false
    
    var stubAuthorizationStatus: LocationAuthorizationStatus = .notDetermined
    var stubCoordinateResult: Result<Coordinate, Error> = .failure(NSError(domain: "", code: -1))
    
    func stubAuthorized(_ authorized: Bool) { stubAuthorizationStatus = authorized ? .authorized : .denied }
    func stubCoordinateSuccess(_ coord: Coordinate) { stubCoordinateResult = .success(coord) }
    func stubCoordinateFailure(_ error: Error = NSError(domain: "", code: -1)) { stubCoordinateResult = .failure(error) }
    
    func currentAuthorizationStatus() -> LocationAuthorizationStatus {
        currentAuthorizationStatusCalled = true
        return stubAuthorizationStatus
    }
    
    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCalled = true
    }
    
    func fetchCurrentCoordinate() async throws -> Coordinate {
        fetchCurrentCoordinateCalled = true
        switch stubCoordinateResult {
            case .success(let coord): return coord
            case .failure(let error): throw error
        }
    }
}

// Simple icon loader mock
final class MockIconLoader: WeatherIconLoading {
    private(set) var requestedCode: String?
    var nextResult: Result<UIImage, Error> = .failure(NSError(domain: "", code: -1))
    func loadIcon(for code: String) async throws -> UIImage {
        requestedCode = code
        switch nextResult {
            case .success(let image): return image
            case .failure(let error): throw error
        }
    }
    func cancelLoad(for code: String) { /* no-op for tests */ }
}

// In-memory store reused here
final class InMemoryLastKnownStateStore_ForWeather: LastKnownAppStateStoring {
    private var state: LastKnownAppState = LastKnownAppState(
        lastSearchedCity: "Saved City",
        lastResolvedCoordinate: nil,
        lasSuccessfulWeatherFetch: nil
    )
    func save(_ state: LastKnownAppState) { self.state = state }
    func load() -> LastKnownAppState { state }
    func clear() { state = LastKnownAppState() }
}
