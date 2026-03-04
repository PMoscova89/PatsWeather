//
//  DiskImageCache.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import UIKit

final class DiskImageCache : ImageCaching {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectory = urls[0].appendingPathComponent("WeatherIconCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func image(forKey key: String) -> UIImage? {
        let url = cacheDirectory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: url) else {return nil}
        return UIImage(data: data)
    }

    func insert(_ image: UIImage, forKey key: String) {
        let url = cacheDirectory.appendingPathComponent(key)
        guard let data = image.pngData() else {return}
        try? data.write(to: url)
    }

    func removeImage(forKey key: String) {
        let url = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: url)
    }

  
}
