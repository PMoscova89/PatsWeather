//
//  LocationServiceTests.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/11/26.
//

import Testing
import CoreLocation
@testable import PatsWeather


// MARK: - Tests

@Suite("CLLocationManagerLocationService")
struct CLLocationManagerLocationServiceTests {
    
    @Test("Maps authorization statuses correctly")
    func mapsAuthorizationStatus() {
        let mock = MockCLLocationManager()
        let sut = CLLocationManagerLocationService(manager: mock)
        
        mock.stubAuthorizationStatus = .notDetermined
        #expect(sut.currentAuthorizationStatus() == .notDetermined)
        
        mock.stubAuthorizationStatus = .restricted
        #expect(sut.currentAuthorizationStatus() == .restricted)
        
        mock.stubAuthorizationStatus = .denied
        #expect(sut.currentAuthorizationStatus() == .denied)
        
        mock.stubAuthorizationStatus = .authorizedWhenInUse
        #expect(sut.currentAuthorizationStatus() == .authorized)
        
        mock.stubAuthorizationStatus = .authorizedAlways
        #expect(sut.currentAuthorizationStatus() == .authorized)
    }
    
    @Test("requestWhenInUseAuthorization calls through to manager")
    func requestAuthorization_callsManager() {
        let mock = MockCLLocationManager()
        let sut = CLLocationManagerLocationService(manager: mock)
        
        sut.requestWhenInUseAuthorization()
        #expect(mock.didRequestWhenInUseAuthorization == true)
    }
    
    @Test("fetchCurrentCoordinate throws when not authorized")
    func fetch_notAuthorized_throws() async {
        let mock = MockCLLocationManager()
        mock.stubAuthorizationStatus = .denied
        let sut = CLLocationManagerLocationService(manager: mock)
        
        await #expect(throws: LocationServiceError.notAuthorized) {
            _ = try await sut.fetchCurrentCoordinate()
        }
        #expect(mock.didRequestLocation == false)
    }
    
    @Test("fetchCurrentCoordinate resolves with coordinate on success")
    func fetch_success_returnsCoordinate() async throws {
        let mock = MockCLLocationManager()
        mock.stubAuthorizationStatus = .authorizedWhenInUse
        let sut = CLLocationManagerLocationService(manager: mock)
        
        async let result: Coordinate = try sut.fetchCurrentCoordinate()
        // Simulate async delegate update
        mock.simulateUpdate(latitude: 37.3349, longitude: -122.0090)
        
        let coord = try await result
        #expect(coord == Coordinate(latitude: 37.3349, longitude: -122.0090))
        #expect(mock.didRequestLocation == true)
    }
    
    @Test("fetchCurrentCoordinate throws unableToDetermineLocation when no locations are provided")
    func fetch_emptyLocations_throws() async {
        let mock = MockCLLocationManager()
        mock.stubAuthorizationStatus = .authorizedWhenInUse
        let sut = CLLocationManagerLocationService(manager: mock)
        
        let task = Task { try await sut.fetchCurrentCoordinate() }
        mock.simulateEmptyUpdate()
        
        await #expect(throws: LocationServiceError.unableToDetermineLocation) {
            _ = try await task.value
        }
    }
    
    @Test("fetchCurrentCoordinate throws underlying error when manager fails")
    func fetch_failure_throwsUnderlying() async {
        let mock = MockCLLocationManager()
        mock.stubAuthorizationStatus = .authorizedWhenInUse
        let sut = CLLocationManagerLocationService(manager: mock)
        
        let task = Task { try await sut.fetchCurrentCoordinate() }
        let nsError = NSError(domain: "Test", code: 42)
        mock.simulateFailure(nsError)
        
        await #expect(throws: LocationServiceError.underlying(nsError.localizedDescription)) {
            _ = try await task.value
        }
    }
}
