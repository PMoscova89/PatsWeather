//
//  OpenWeatherWeatherService.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

protocol WeatherServiceType {
    func fetchWeather(for coordinate: Coordinate, excludeParts: [String]) async throws -> WeatherReport
}

final class OpenWeatherWeatherService: WeatherServiceType {
    private let endpointFactory: OpenWeatherEndpointBuilding
    private let requestBuilder: RequestBuilding
    private let httpClient: HTTPClient
    private let mapper: OpenWeatherOneCallMapping
    private let jsonDecoder: JSONDecoder
    
    init(endpointFactory: OpenWeatherEndpointBuilding
         , requestBuilder: RequestBuilding,
         httpClient: HTTPClient,
         mapper: OpenWeatherOneCallMapping = OpenWeatherOneCallMapper(),
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.endpointFactory = endpointFactory
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
        self.mapper = mapper
        self.jsonDecoder = jsonDecoder
    }
    
    func fetchWeather(for coordinate: Coordinate, excludeParts: [String] = []) async throws -> WeatherReport {
        let endpoint = endpointFactory.makeOneCallEndpoint(coordinate: coordinate, excludeParts: excludeParts)
        
        let request = try requestBuilder.makeRequest(from: endpoint)
        let data = try await httpClient.perform(request)
        
        do{
            let dto = try jsonDecoder.decode(OpenWeatherOneCallDTO.self, from: data)
            guard let report = mapper.mapToWeatherReport(dto) else {
                throw NetworkError.decodingFailed("Mapping failed because required fields were missing")
            }
            return report
        }catch let error as NetworkError {
            throw error
        }catch {
            throw NetworkError.decodingFailed(error.localizedDescription)
        }
    }
}
