//
//  LastKnownAppStateStoring.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

protocol LastKnownAppStateStoring {
    func load() -> LastKnownAppState
    func save(_ state: LastKnownAppState)
    func clear()
}
