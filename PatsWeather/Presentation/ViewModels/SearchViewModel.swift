//
//  SearchViewModel.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation
import Observation

@Observable
final class SearchViewModel {
    var cityInput: String = ""
    var status: SearchStatus = .idle
    
    @ObservationIgnored private let geocodingService: GeocodingServiceType
    private let lastKnownStateStore: LastKnownAppStateStoring
    
    init(geocodingService: GeocodingServiceType,
         lastKnownStateStore: LastKnownAppStateStoring) {

        self.geocodingService = geocodingService
        self.lastKnownStateStore = lastKnownStateStore
    }
    
    func restoreCityIfAvailable(_ city: String?) {
        guard let city, !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        cityInput = city
    }
    
    func validateCityInput() -> Bool {
        status = .validating
        
        let trimmed = cityInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmed.count >= 2 else {
            status = .failed(message: "Enter a valid city name.")
            return false
        }
        status = .idle
        return true
    }
    
    func search() async {
        guard validateCityInput() else {return}
        let city = cityInput.trimmingCharacters(in: .whitespacesAndNewlines)
        status = .searching
        
        do{
            let coordinate = try await geocodingService.fetchCoordinate(for: city)
            
            let updatedState = LastKnownAppState(
                lastSearchedCity: city,
                lastResolvedCoordinate: coordinate,
                lasSuccessfulWeatherFetch: nil
            )
            lastKnownStateStore.save(updatedState)
            
            status = .succeeded(city: city, coordinate: coordinate)
        }catch{
            status = .failed(message: "Could not find that city. Try again.")
        }
    }
}
