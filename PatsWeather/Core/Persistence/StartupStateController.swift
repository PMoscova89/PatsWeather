//
//  StartupStateController.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

enum AppLaunchDecision: Equatable {
    case showEmptySearch
    case restoreLastCity(city: String)
    case restoreLastCityAndCoordinate(city: String, coordinate: Coordinate)
}

protocol AppLaunchStateRestoring {
    func determineLaunchDecision() -> AppLaunchDecision
}

final class StartupStateController: AppLaunchStateRestoring {

    private let store: LastKnownAppStateStoring
    
     init(store: LastKnownAppStateStoring) {
        self.store = store
    }
    
    func determineLaunchDecision() -> AppLaunchDecision {
        let state = store.load()
        
        guard let city = state.lastSearchedCity, !city.isEmpty else {
            return .showEmptySearch
        }
        
        if let coordinate = state.lastResolvedCoordinate {
            return .restoreLastCityAndCoordinate(city: city, coordinate: coordinate)
        }
        return .restoreLastCity(city: city)
    }

    
}
