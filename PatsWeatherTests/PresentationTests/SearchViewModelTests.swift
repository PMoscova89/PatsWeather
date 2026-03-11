//
//  SearchViewModelTests.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/11/26.
//

import Testing
@testable import PatsWeather
// Simple in-memory store for tests
final class InMemoryLastKnownStateStore: LastKnownAppStateStoring {
    private var state: LastKnownAppState = LastKnownAppState(
        lastSearchedCity: nil,
        lastResolvedCoordinate: nil,
        lasSuccessfulWeatherFetch: nil
    )
    func save(_ state: LastKnownAppState) { self.state = state }
    func load() -> LastKnownAppState { state }
    func clear() { self.state = LastKnownAppState() }
}

@Suite("SearchViewModel")
struct SearchViewModelTests {
    @Test("restoreCityIfAvailable sets cityInput when non-empty")
    func restore_setsCity() {
        let geocoder = MockGeocodingService()
        let store = InMemoryLastKnownStateStore()
        let vm = SearchViewModel(geocodingService: geocoder, lastKnownStateStore: store)
        
        vm.restoreCityIfAvailable("  Cupertino  ")
        #expect(vm.cityInput == "  Cupertino  ")
    }
    
    @Test("restoreCityIfAvailable ignores nil/empty")
    func restore_ignoresEmpty() {
        let geocoder = MockGeocodingService()
        let store = InMemoryLastKnownStateStore()
        let vm = SearchViewModel(geocodingService: geocoder, lastKnownStateStore: store)
        
        vm.cityInput = "Existing"
        vm.restoreCityIfAvailable(nil)
        #expect(vm.cityInput == "Existing")
        vm.restoreCityIfAvailable("   ")
        #expect(vm.cityInput == "Existing")
    }
    
    @Test("validateCityInput fails for < 2 chars")
    func validate_failsShort() {
        let geocoder = MockGeocodingService()
        let store = InMemoryLastKnownStateStore()
        let vm = SearchViewModel(geocodingService: geocoder, lastKnownStateStore: store)
        
        vm.cityInput = "A"
        let valid = vm.validateCityInput()
        #expect(valid == false)
        if case .failed(let message) = vm.status {
            #expect(message.contains("valid city"))
        } else {
            Issue.record("Expected failed status")
        }
    }
    
    @Test("validateCityInput succeeds and resets status")
    func validate_succeeds() {
        let geocoder = MockGeocodingService()
        let store = InMemoryLastKnownStateStore()
        let vm = SearchViewModel(geocodingService: geocoder, lastKnownStateStore: store)
        
        vm.cityInput = "Cupertino"
        let valid = vm.validateCityInput()
        #expect(valid == true)
        #expect(vm.status == .idle)
    }
    
    @Test("search success updates state and status")
    func search_success() async {
        let geocoder = MockGeocodingService()
        let store = InMemoryLastKnownStateStore()
        let vm = SearchViewModel(geocodingService: geocoder, lastKnownStateStore: store)
        vm.cityInput = "Cupertino"
        geocoder.stubSuccess(Coordinate(latitude: 37.3349, longitude: -122.0090))
        
        await vm.search()
        
        // Status should be succeeded
        if case .succeeded(let city, let coord) = vm.status {
            #expect(city == "Cupertino")
            #expect(coord == Coordinate(latitude: 37.3349, longitude: -122.0090))
        } else {
            Issue.record("Expected succeeded status")
        }
        
        // Store should be updated
        let saved = store.load()
        #expect(saved.lastSearchedCity == "Cupertino")
        #expect(saved.lastResolvedCoordinate == Coordinate(latitude: 37.3349, longitude: -122.0090))
        #expect(saved.lasSuccessfulWeatherFetch == nil)
    }
    
    @Test("search failure sets failed status")
    func search_failure() async {
        let geocoder = MockGeocodingService()
        let store = InMemoryLastKnownStateStore()
        let vm = SearchViewModel(geocodingService: geocoder, lastKnownStateStore: store)
        vm.cityInput = "X"
        geocoder.stubFailure()
        
        await vm.search()
        
        if case .failed(let message) = vm.status {
            #expect(message.contains("Enter a valid city name."))
        } else {
            Issue.record("Expected failed status")
        }
    }
}

