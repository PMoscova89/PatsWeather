//
//  WeatherViewModel.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation
import Observation
import UIKit


@Observable
final class WeatherViewModel {
    var weatherStatus: WeatherStatus = .idle
    var iconStatus: IconStatus = .idle
    var iconImage: UIImage? = nil
    
    private let weatherService: WeatherServiceType
    private let iconLoader: WeatherIconLoading
    private let lastKnownStateStore: LastKnownAppStateStoring
    private let locationService: LocationServiceType?
    
    init(
        weatherService: WeatherServiceType,
        iconLoader: WeatherIconLoading,
        lastKnownStateStore: LastKnownAppStateStoring,
        locationService: LocationServiceType? = nil
    ){
        self.weatherService = weatherService
        self.iconLoader = iconLoader
        self.lastKnownStateStore = lastKnownStateStore
        self.locationService = locationService
    }
    
    
    func fetchWeather(for coordinate: Coordinate, excludeParts parts: [String] = []) async {
        weatherStatus = .loading
        iconStatus = .idle
        iconImage = nil
        
        do {
            let report = try await weatherService.fetchWeather(for: coordinate, excludeParts: parts)
            let current = lastKnownStateStore.load()
            let displayName = current.lastSearchedCity ?? "Current Location"
            weatherStatus = .success(report: report, locationName: displayName)
            
            let updated = LastKnownAppState(
                lastSearchedCity: current.lastSearchedCity,
                lastResolvedCoordinate: coordinate,
                lasSuccessfulWeatherFetch: Date()
            )
            lastKnownStateStore.save(updated)
            await loadIconIfAvailable(from: report)
        }catch {
            weatherStatus = .failed(message: "Weather could not be loaded. Try again.")
        }
    }
    
    func fetchWeatherUsingLocationIfAuthorized() async {
        guard let locationService else {
            weatherStatus = .failed(message: "Location service is unavailable.")
            return
        }
        let status = locationService.currentAuthorizationStatus()
        
        switch status {
            case .authorized:
                do {
                    let coordinate = try await locationService.fetchCurrentCoordinate()
                    
                    let current = lastKnownStateStore.load()
                    let updated = LastKnownAppState(
                        lastSearchedCity: nil,
                        lastResolvedCoordinate: current.lastResolvedCoordinate,
                        lasSuccessfulWeatherFetch: current.lasSuccessfulWeatherFetch
                    )
                    lastKnownStateStore.save(updated)
                    
                    await fetchWeather(for: coordinate)
                } catch {
                    weatherStatus = .failed(message: "Could not get your location. You can search by city")
                }
                
            case .notDetermined:
                locationService.requestWhenInUseAuthorization()
                weatherStatus = .failed(message: "Allow location to use this feature or search by city")
            case .denied, .restricted:
                weatherStatus = .failed(message: "Location is off, Search by city instead")
        }
    }
    
    func cancelIconLoadIfNeeded(code: String){
        iconLoader.cancelLoad(for: code)
    }
    
    func loadIconIfAvailable(from report: WeatherReport) async {
        guard let iconCode = report.current.condition.icon, !iconCode.isEmpty else{
            return
        }
        
        iconStatus = .loading(code: iconCode)
        
        do {
            let image = try await iconLoader.loadIcon(for: iconCode)
            iconImage = image
            iconStatus = .success(code: iconCode)
        }catch {
            iconStatus = .failed(code: iconCode)
        }
    }
}
