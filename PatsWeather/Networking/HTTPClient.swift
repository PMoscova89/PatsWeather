//
//  HTTPClient.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import Foundation

protocol HTTPClient {
    func perform(_ request: URLRequest) async throws -> Data
}
