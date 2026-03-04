//
//  WeatherIconLoader.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import UIKit

protocol WeatherIconLoading {
    func loadIcon(for iconCode: String) async throws -> UIImage
    func cancelLoad(for iconCode: String)
}

final class WeatherIconLoader : WeatherIconLoading {
    
    private let urlBuilder: WeatherIconURLBuilding
    private let httpClient: HTTPClient
    private let memoryCache: ImageCaching
    private let diskCache: ImageCaching?
    
    private var tasks: [String: Task<UIImage, Error>] = [:]
    
    
    init(urlBuilder: WeatherIconURLBuilding,
         httpClient: HTTPClient,
         memoryCache: ImageCaching,
         diskCache: ImageCaching? = nil,
      ) {
        self.urlBuilder = urlBuilder
        self.httpClient = httpClient
        self.memoryCache = memoryCache
        self.diskCache = diskCache
    }
    
    func loadIcon(for iconCode: String) async throws -> UIImage {
        if let cached = memoryCache.image(forKey: iconCode){
            return cached
        }
        
        
        if let diskCache,
           let diskImage = diskCache.image(forKey: iconCode){
            memoryCache.insert(diskImage, forKey: iconCode)
            return diskImage
        }
        
        guard let url = urlBuilder.makeIconURL(for: iconCode) else {
            throw NetworkError.invalidURL
        }
        
        if let existingTask = tasks[iconCode] {
            return try await existingTask.value
        }
        
        let task = Task<UIImage, Error> {
            defer {tasks[iconCode] = nil}
            let request = URLRequest(url:url)
            let data = try await httpClient.perform(request)
            guard let image = UIImage(data: data) else {
                throw NetworkError.decodingFailed("Invalid Image Data")
            }
            memoryCache.insert(image, forKey: iconCode)
            diskCache?.insert(image, forKey: iconCode)
            return image
        }
        tasks[iconCode] = task
        return try await task.value
        
    }

    func cancelLoad(for iconCode: String) {
        tasks[iconCode]?.cancel()
        tasks[iconCode] = nil
    }

    
}
