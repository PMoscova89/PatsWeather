//
//  OpenWeatherGeocodingService.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

protocol GeocodingServiceType {
    func fetchCoordinate(for city: String) async throws -> Coordinate
}


final class OpenWeatherGeocodingService: GeocodingServiceType {
    private let endpointFactory: OpenWeatherEndpointBuilding
    private let requestBuilder: RequestBuilding
    private let httpClient: HTTPClient
    private let mapper: OpenWeatherGeocodingMapping
    private let decoder: JSONDecoder
    
    init(endpointFactory: OpenWeatherEndpointBuilding,
         requestBuilder: RequestBuilding,
         httpClient: HTTPClient,
         mapper: OpenWeatherGeocodingMapping = OpenWeatherGeocodingMapper(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.endpointFactory = endpointFactory
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
        self.mapper = mapper
        self.decoder = decoder
    }
    
    func fetchCoordinate(for city: String) async throws -> Coordinate {
        let endpoint = endpointFactory.makeGeocodingEndpoint(city: city, limit: 1)
        let request = try requestBuilder.makeRequest(from: endpoint)
        let data = try await httpClient.perform(request)
        
        do{
            let results = try decoder.decode([OpenWeatherGeocodingDTO].self, from: data)
            guard let first = results.first else {
                throw NetworkError.transportError("No geocoding results for city: \(city)")
            }
            return mapper.mapToCoordinatoe(first)
        }catch let error as NetworkError {
            throw error
        }catch {
            throw NetworkError.decodingFailed(error.localizedDescription)
        }
    }
}
