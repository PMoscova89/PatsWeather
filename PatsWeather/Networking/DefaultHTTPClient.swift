//
//  DefaultHTTPClient.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

final class DefaultHTTPClient: HTTPClient {
    private let session: URLSession
    private let validator: ResponseValidating
    
    init(session: URLSession = .shared, validator: ResponseValidating = ResponseValidator()) {
        self.session = session
        self.validator = validator
    }
    
    func perform(_ request: URLRequest) async throws -> Data {
        do {
            if let url = request.url {
                print("Final URL:", url.absoluteString)
                print("Query:", URLComponents(url: url, resolvingAgainstBaseURL: false)?.query ?? "nil")
            }
            let (data, response) = try await session.data(for: request)
            return try validator.validate(data: data, response: response)
        }catch let error as NetworkError{
            print("\(error.localizedDescription)")
            throw error
        }catch {
            throw NetworkError.map(error)
        }
    }
}

extension DefaultHTTPClient {
    func perform<T: Decodable>(
        _ request: URLRequest,
        decode type: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let data = try await perform(request)
        do{
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error.localizedDescription)
        }
    }
}
