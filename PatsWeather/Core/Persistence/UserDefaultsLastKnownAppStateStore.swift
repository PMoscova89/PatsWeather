//
//  UserDefaultsLastKnownAppStateStore.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

final class UserDefaultsLastKnownAppStateStore: LastKnownAppStateStoring {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let storageKey: String
    
    init(userDefaults: UserDefaults = .standard,
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder(),
         storageKey: String = "lastKnownAppState") {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
        self.storageKey = storageKey
    }
    
    func load() -> LastKnownAppState {
        guard let data = userDefaults.data(forKey: storageKey) else {
            return LastKnownAppState()
        }
        do {
            return try decoder.decode(LastKnownAppState.self, from: data)
        }catch{
            return LastKnownAppState()
        }
    }
    
    func save(_ state: LastKnownAppState) {
        do{
            let data = try encoder.encode(state)
            userDefaults.set(data, forKey: storageKey)
        }catch{
            
        }
    }
    
    func clear() {
        userDefaults.removeObject(forKey: storageKey)
    }
}
