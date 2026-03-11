//
//  WeatherViewModelTests.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/11/26.
//

import Testing
import UIKit
@testable import PatsWeather


@Suite("WeatherViewModel")
struct WeatherViewModelTests {
    @Test("fetchWeather success updates status and saves state, then loads icon")
    func fetchWeather_success_loadsIcon() async {
        let weatherService = MockWeatherService()
        let iconLoader = MockIconLoader()
        let store = InMemoryLastKnownStateStore_ForWeather()
        let vm = WeatherViewModel(
            weatherService: weatherService,
            iconLoader: iconLoader,
            lastKnownStateStore: store,
            locationService: nil
        )
        
        let coord = Coordinate(latitude: 37.3349, longitude: -122.0090)
        let base = MockData.decodedWeatherReport
        // Ensure we have an icon code to trigger icon load using copy helpers
        let updatedCurrent = base.current.with(
            condition: WeatherCondition(
                id: base.current.condition.id,
                main: base.current.condition.main,
                description: base.current.condition.description,
                icon: "01d"
            )
        )
        let report = base.with(current: updatedCurrent)
        weatherService.stubSuccess(report)
        
        await vm.fetchWeather(for: coord)
        
        // Status should be success with location name from store
        switch vm.weatherStatus {
        case .success(let returnedReport, let locationName):
            #expect(returnedReport == report)
            #expect(locationName == "Saved City")
        default:
            Issue.record("Expected success status")
        }
        
        // Icon should be requested and status updated
        #expect(vm.iconStatus == .success(code: "01d"))
        #expect(iconLoader.requestedCode == "01d")
        #expect(vm.iconImage != nil)
    }
    
    @Test("fetchWeather failure sets failed status")
    func fetchWeather_failure_setsFailed() async {
        let weatherService = MockWeatherService()
        let iconLoader = MockIconLoader()
        let store = InMemoryLastKnownStateStore_ForWeather()
        let vm = WeatherViewModel(
            weatherService: weatherService,
            iconLoader: iconLoader,
            lastKnownStateStore: store,
            locationService: nil
        )
        
        weatherService.stubFailure(NSError(domain: "Test", code: 1))
        await vm.fetchWeather(for: Coordinate(latitude: 0, longitude: 0))
        
        if case .failed(let message) = vm.weatherStatus {
            #expect(!message.isEmpty)
        } else {
            Issue.record("Expected failed status")
        }
    }
    
    @Test("fetchWeatherUsingLocationIfAuthorized handles auth and errors")
    func fetchUsingLocation_handlesAuthorization() async {
        let weatherService = MockWeatherService()
        let iconLoader = MockIconLoader()
        let store = InMemoryLastKnownStateStore_ForWeather()
        let spyLocation = SpyLocationService()
        let vm = WeatherViewModel(
            weatherService: weatherService,
            iconLoader: iconLoader,
            lastKnownStateStore: store,
            locationService: spyLocation
        )
        
        // Not determined -> requests auth and sets failed message
        spyLocation.stubAuthorizationStatus = .notDetermined
        await vm.fetchWeatherUsingLocationIfAuthorized()
        if case .failed(let message) = vm.weatherStatus {
            #expect(message.contains("Allow location"))
        } else {
            Issue.record("Expected failed status for notDetermined")
        }
        
        // Denied -> sets failed message
        spyLocation.stubAuthorizationStatus = .denied
        await vm.fetchWeatherUsingLocationIfAuthorized()
        if case .failed(let message) = vm.weatherStatus {
            #expect(message.contains("Location is off"))
        } else {
            Issue.record("Expected failed status for denied")
        }
        
        // Authorized but fetching coordinate fails
        spyLocation.stubAuthorizationStatus = .authorized
        spyLocation.stubCoordinateFailure()
        await vm.fetchWeatherUsingLocationIfAuthorized()
        if case .failed(let message) = vm.weatherStatus {
            #expect(message.contains("Could not get your location"))
        } else {
            Issue.record("Expected failed status for coord error")
        }
        
        // Authorized and coordinate succeeds -> weather service success
        spyLocation.stubCoordinateSuccess(Coordinate(latitude: 1, longitude: 2))
        let baseSuccess = MockData.decodedWeatherReport
        let updatedCurrentSuccess = baseSuccess.current.with(
            condition: WeatherCondition(
                id: baseSuccess.current.condition.id,
                main: baseSuccess.current.condition.main,
                description: baseSuccess.current.condition.description,
                icon: nil
            )
        )
        let successReport = baseSuccess.with(current: updatedCurrentSuccess)
        weatherService.stubSuccess(successReport)
        await vm.fetchWeatherUsingLocationIfAuthorized()
        if case .success = vm.weatherStatus {
            // ok
        } else {
            Issue.record("Expected success status when authorized and services succeed")
        }
    }
}

extension WeatherReport {
    func with(current: CurrentWeather) -> WeatherReport {
        WeatherReport(
            timezone: timezone,
            current: current,
            hourly: hourly,
            daily: daily,
            alerts: alerts
        )
    }
}

extension WeatherReport.CurrentWeather {
    func with(condition: WeatherCondition) -> WeatherReport.CurrentWeather {
        WeatherReport.CurrentWeather(
            timestamp: timestamp,
            sunrise: sunrise,
            sunset: sunset,
            temperature: temperature,
            feelsLike: feelsLike,
            humidity: humidity,
            windSpeed: windSpeed,
            condition: condition
        )
    }
}
